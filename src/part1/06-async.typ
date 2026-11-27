#import "../../lib.typ": *
= Chapter 6. Asynchrony

#tag[●] Why and when to decouple. #tag[◐] Delivery guarantees, retries, queue maths. #tag[◆] Ordering, outbox, and operating lag.

#callout("predict")[
When a PorchLend owner taps "Approve loan", the system must: update the loan, notify the borrower, update the search index, and send a confirmation email. Which of those must finish *before* the owner sees "Approved"? Which could happen *later*? What if the email service is down for an hour?

#lines(4)
]

== 6.1 Synchronous vs asynchronous

In a *synchronous* call, the caller waits for the answer. In an *asynchronous* one, the caller hands off work and moves on; the work happens later, elsewhere.

Asynchrony buys three things:

- *Speed for the user:* do only the essential work before replying.
- *Resilience:* if a downstream service is down, work waits instead of failing.
- *Smoothing:* bursts are absorbed in a queue and processed at a steady pace.

It costs you: *work happens later* (users may see old state), *ordering and duplicates become your problem*, and *debugging is harder* because cause and effect are separated in time.

#callout("keyidea")[
*Do synchronously what the user must see to trust the result. Do asynchronously what the user only needs eventually.* The test: "if this step fails, can we retry it without the user noticing?"
]

(Predict answer: the loan update must be done before replying. Notification, index update and email can be later. If email is down, the queue holds the messages and delivery resumes later.)

== 6.2 Three shapes of asynchronous messaging

#table(columns: (29fr, 61fr, 61fr, 61fr),
  [*Shape*], [*What it is*], [*Good for*], [*Notes*],
  [*Queue*], [Each message goes to _one_ worker, then it is gone], [Background jobs: resize photo, send email], [Workers compete for messages; scale by adding workers],
  [*Publish / subscribe*], [Each message goes to _every_ interested subscriber], [Fan-out: "loan approved" tells notifications, search, analytics], [Subscribers are decoupled from the publisher],
  [*Log / stream*], [An ordered, retained sequence that consumers read at their own position], [Replaying history, many readers, event pipelines], [Messages stay for a retention period; consumers track their offset],
)

The Kafka paper (see sources) is a good origin story for the log model; today several systems implement variants of it.

== 6.3 What does "delivered" mean?

#block(sticky: true)[Networks and processes fail between "message sent" and "work done". So systems promise one of three things:]

#table(columns: (23fr, 41fr, 61fr),
  [*Guarantee*], [*Meaning*], [*Consequence*],
  [*At most once*], [Might be lost, never duplicated], [Fine for low-value signals],
  [*At least once*], [Never lost, *may be duplicated*], [The usual default; you must handle duplicates],
  [*Exactly once*], [Each message has exactly one effect], [Achievable only in limited settings; in practice, *at-least-once delivery plus idempotent processing*],
)

An operation is *idempotent* if doing it twice has the same effect as doing it once. "Set loan status to approved" is idempotent. "Add 1 to the borrow count" is not. Make operations idempotent by giving every message a *unique ID* and recording the IDs you have processed (or by writing the operation as "set to X").

#callout("worked")[
*PorchLend "Loan approved" event.*

1. The approve request updates the loan row *and* writes an event row ("loan 8841 approved", unique ID) in *the same database transaction*. (This is the _outbox_ pattern: the event cannot be lost, nor sent without the update.)
2. A relay reads new outbox rows and publishes them to the message system.
3. Consumers: _notifications_ (push + email), _search indexer_, _analytics_. Each consumer keeps a table of processed event IDs, so a duplicate delivery is ignored.
4. If the email provider is down, the notification consumer retries with *exponential backoff and jitter* (below), and after N failures moves the message to a *dead-letter queue* for a human to inspect.
]

== 6.4 Retries, backoff and poison messages

- *Retry* transient failures, but not forever.
- *Exponential backoff:* wait 1 s, then 2, 4, 8... so you do not hammer a struggling service.
- *Jitter:* randomise the wait (for example, a random time up to the backoff cap) so thousands of clients do not retry in lockstep.
- *Dead-letter queue (DLQ):* after the retry limit, park the message somewhere visible instead of blocking the line or silently dropping it. *A DLQ nobody monitors is a data-loss mechanism.*
- *Poison message:* a message that always crashes its consumer. Without a retry limit and DLQ, it blocks the queue forever.

== 6.5 Queue maths: how many workers?

*Little's Law:* the average number of items in a system equals the arrival rate times the average time each spends in it.

#block(stroke: (left: 2pt + black), inset: (left: 3mm, y: 1mm), width: 100%)[*L = λ × W*]

If messages arrive at λ per second and each takes W seconds to process, then about *λ × W workers are busy* on average.

#callout("worked")[
*Photo-resizing jobs.* 200 uploads/s at peak; each resize takes 50 ms of a worker's time.

- Busy workers = 200 × 0.05 = *10*. That is 100% utilisation, no slack.
- At a healthy 70% utilisation: 10 ÷ 0.7 ≈ *15 workers*.

*Recovery after an outage.* Workers are down for 10 minutes: backlog = 10 × 60 × 200 = *120,000 jobs*. With 20 workers the capacity is 20 ÷ 0.05 = 400 jobs/s. New work still arrives at 200/s, so the backlog shrinks at 200/s: 120,000 ÷ 200 = *600 s = 10 more minutes* to drain. With only 15 workers (300/s), it drains at 100/s: *20 minutes*.

_Insight:_ recovery time depends on *spare capacity*, not on total capacity. A system running at 95% busy takes forever to catch up.
]

== 6.6 Ordering, backpressure and monitoring

#callout("mid")[
*Ordering.* Most systems guarantee order only *within a partition or key*, not globally. If "loan created" and "loan cancelled" for loan 8841 must be processed in order, send both with the same key (the loan ID) so they land in the same partition and are handled sequentially. Global order is expensive; per-key order is usually enough.

*Backpressure.* If producers are faster than consumers, something must give. Options: block producers, reject with "try later", drop low-priority work, or scale consumers. An unbounded queue is not a solution; it is a delayed outage with a bigger blast radius. *Always bound queues and decide what happens when full.*

*Monitor the right things:* queue depth, _age of the oldest message_, consumer lag, processing rate, retries, DLQ size. The oldest-message age shows the _user-visible delay_; depth alone does not.
]

#callout("deepen")[
*Exactly-once is a property of a whole pipeline, not a message system.* If your consumer writes to a database and then acknowledges the message, a crash between the two causes a duplicate. Make the consumer's write and the "I've processed ID X" record part of *one transaction*, or make the write idempotent.

*Dual-write bugs.* Updating a database and publishing a message as two separate steps leaves a window where one succeeds and the other fails. The outbox pattern (or change-data-capture from the database log) closes it. Avoid "write to database, then publish" in application code.

*Consumer lag is a latency SLO.* Define "notifications within 30 seconds, 99% of the time" and alert on message age, not just on errors.

*Replay is a feature and a hazard.* Logs let you rebuild a search index from history, but replaying old events can resend old emails. Make replays safe by separating _rebuilding derived state_ from _triggering side effects_.

*Fan-out amplification.* One event delivered to 10 consumers, each of which fires 3 calls, is 30 downstream calls. Budget for it.
]

#callout("interview")[
When you add a queue, say what happens on duplicate delivery, on a poison message, and when the queue fills. "Exactly once" is a red flag unless you immediately explain idempotency. Say how you would monitor it: message age and consumer lag, not just depth.
]

#checks-block((
  [800 messages per second arrive; each takes 20 ms. How many workers for 60% utilisation?],
  [Why is "write to database, then publish to queue" in application code dangerous?],
  [What is wrong with an unbounded queue in front of a slow consumer?],
  [Which of these is idempotent: "set status = shipped", "increment counter", "append to list"? Make the other two safe.],
))


#interview-round(6, "Decouple it: reliable notifications",
  "When an owner approves a loan, the borrower gets a push and an email, the search index updates, and analytics records it. Design it so nothing is lost if the email provider is down for an hour.",
  clarify: 3,
  est-title: "Queue maths (50 approvals / s at peak, 4 jobs each)",
  est-cols: ("Quantity", "Calculation", "Result"),
  est-rows: ("Job rate", "Workers (100 ms / job, 60% busy)", "Email backlog after a 1 h outage", "Drain time at 2x email capacity"),
  row-h: 6.5mm,
  sketch-h: 44mm, trade-rows: 2,
  twist: "The SMS provider allows only 100 messages per second and you must send 150,000 overdue reminders at midnight. How long does it take, and what do you tell product?",
  twist-lines: 3)
