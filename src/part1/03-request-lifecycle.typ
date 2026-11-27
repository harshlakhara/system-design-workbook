#import "../../lib.typ": *
= Chapter 3. The life of a request

#tag[●] The path of one request. #tag[◐] Load balancing and connection costs. #tag[◆] Failure and tail behaviour at the edge.

#callout("predict")[
A user in Mumbai opens `porchlend.example` for the first time on a phone. List, in order, *every network step* that happens before the first byte of the page appears. Guess how many round trips that costs if each trip to your server takes 100 ms.

#lines(4)
]

== 3.1 One request, step by step

When a client calls your service, this is the journey (simplified):

1. *DNS lookup.* The name is turned into an IP address. Answers are cached at several levels for a time set by the record's _TTL_.
2. *Connection setup.* With TCP, the client and server exchange a handshake (1 round trip) before any data flows.
3. *Encryption setup.* TLS adds its own handshake. With TLS 1.3 this is typically 1 more round trip on a fresh connection; resuming a previous session can reduce it.
4. *The request itself*, and the first bytes of the response (1 more round trip).
5. *Edge or load balancer* receives it and picks a backend.
6. *Application server* runs your code, which may call caches, databases and other services.
7. *Response travels back*, perhaps through the same path.

#callout("keyidea")[
*A cold request costs several round trips before any of your code runs.* With a 100 ms round trip, the handshakes alone (TCP, TLS, then the HTTP request) are about 300 ms, plus DNS. A _warm_ connection that is reused costs just the one request round trip. This is why connection reuse, edge termination and CDNs matter so much to far-away users.
]

(So the Predict answer: DNS, TCP, TLS, request, about *3 round trips plus DNS*, around 300 to 400 ms from Mumbai to a distant server; much less if a nearby edge location terminates the connection.)

QUIC and HTTP/3 merge the transport and encryption handshakes, trimming this further on first connections. They run over UDP and are standardised in RFC 9000 (QUIC) and RFC 9114 (HTTP/3).

== 3.2 Where each layer lives

Each layer has one job. After the table, draw them as boxes in the space provided at the end of the chapter, with an arrow for each hop.

#table(columns: (33fr, 61fr, 59fr),
  [*Layer*], [*Job*], [*Typical examples*],
  [*DNS*], [Name to address; can steer users to nearby locations], [Managed DNS with health checks and geographic routing],
  [*CDN / edge*], [Serve cacheable content near the user; terminate TLS early], [Static files, images, cacheable API responses],
  [*Load balancer*], [Spread requests across healthy servers], [Hardware or software; cloud-managed],
  [*Reverse proxy / gateway*], [Routing, authentication, rate limiting, compression], [One front door for many services],
  [*App servers*], [Business logic; should be _stateless_], [Containers, VMs],
  [*Data stores / caches*], [State], [Chapters 4 and 5],
)

*Stateless servers* keep no user-specific data between requests; anything that must persist is stored elsewhere (a database or cache). That lets you add, remove or replace servers freely, because any server can handle any request.

== 3.3 Load balancers

A load balancer receives traffic and forwards it. Two families:

- *Layer 4 (transport level).* Looks at IP and port only. Fast, simple, protocol-agnostic. Cannot see inside the request.
- *Layer 7 (application level).* Understands HTTP: it can route by path or header, terminate TLS, retry, and add authentication. More flexible, more CPU, more to misconfigure.

*Choosing a backend.* Common strategies:

#table(columns: (37fr, 40fr, 43fr, 61fr),
  [*Strategy*], [*How it works*], [*Good when*], [*Weak when*],
  [Round robin], [Next server in the list], [Requests are similar in cost], [Some requests are far heavier than others],
  [Least connections], [Server with fewest active requests], [Requests vary in duration], [Connection counts hide CPU differences],
  [Hash on a key (client, user ID)], [Same key goes to the same server], [You want cache locality or stickiness], [Servers added or removed reshuffle keys (see consistent hashing in Chapter 7)],
  [Weighted], [Bigger servers get more], [Mixed server sizes], [Weights go stale],
)

*Health checks.* The balancer must stop sending traffic to dead servers. A shallow check ("is the port open?") misses a server whose database connection is broken. A deep check ("can I run a trivial query?") can cause a full outage if the _database_ has a brief hiccup and every server marks itself unhealthy at once. Choose deliberately.

#callout("worked")[
*PorchLend front door.* At \~160 peak requests per second the app tier is tiny. Design for *safety*, not scale:

- Two or more stateless app servers behind a managed L7 load balancer, in at least two zones, so one failure is survivable.
- Images served from object storage through a CDN, so photo bandwidth (the real load, per Chapter 2) never touches the app servers.
- TLS terminated at the edge; connection reuse to the app tier.
- Health check: shallow for the load balancer, plus a separate deep "readiness" check used only when deploying.

_Change my mind if:_ peak requests rise 100x. Then think about capacity, autoscaling, and database load, not before.
]

== 3.4 Content delivery networks

A CDN keeps copies of content in many locations close to users. A request that hits the nearby copy never reaches your servers.

- *Static assets* (images, scripts, stylesheets): cache aggressively, and give files unique names when they change ("cache busting") so you never need to purge.
- *Cacheable API responses*: possible when they are the same for many users and a little staleness is fine (for example, "popular tools near this town" for 60 seconds).
- *Private content*: do not cache it at shared caches, or protect it with signed URLs that expire.

#callout("pitfall")[
*Caching personalised responses at a shared cache* is a classic data leak: one user's page is served to another. Mark private responses so shared caches skip them, and test that.
]

#callout("mid")[
*Connection costs and reuse.* Opening a connection is expensive (round trips, CPU for encryption). Servers and clients keep connections open and reuse them ("keep-alive", connection pools). Between your own services, a pool of long-lived connections avoids paying the handshake on every call. Too small a pool serialises requests; too large a pool can overwhelm the destination (databases in particular have connection limits).

*HTTP/1.1 vs HTTP/2.* HTTP/1.1 sends one request at a time per connection, so browsers open several. HTTP/2 multiplexes many requests on one connection, but when TCP loses a packet, _all_ streams on that connection stall ("head-of-line blocking at the transport layer"). HTTP/3 over QUIC avoids that. Semantics are specified in RFC 9110; HTTP/2 in RFC 9113.
]

#callout("deepen")[
*The load balancer is itself a system to design.* It must not be a single point of failure: use several instances behind a stable address (managed by your cloud provider, or by routing the same IP from multiple locations, "anycast").

*DNS is slow to change.* A record's TTL means clients may use an old answer for minutes or hours after you change it. For failover, a short TTL helps, but short TTLs raise DNS load and add lookup latency. Do not rely on DNS alone for fast failover.

*Slow is worse than down.* A dead server is detected and removed. A server that answers in 20 seconds ties up connections and threads across the fleet. Set timeouts at every hop, with _shorter_ timeouts the farther you are from the user.
]

#callout("interview")[
Draw the request path left to right and put a latency or rate on each hop. "What happens when you type a URL?" is asked to see whether you know where time goes. Say where TLS ends and what is cached. When you mention a load balancer, add how it health-checks and what happens when one server dies.
]

#callout("yourturn")[
*Draw it.* The request path for opening PorchLend, left to right. One box per layer, a number (latency or rate) on each arrow, and a mark where TLS ends and where something is cached.
#v(2mm)
#dotbox(62mm)
]

#checks-block((
  [Why can a CDN make a _dynamic_ API faster even if it caches nothing?],
  [What goes wrong if a deep health check queries the database and the database slows down?],
  [Why must app servers be stateless to scale by adding machines? What would you do about a shopping cart?],
  [A user complains the first load is slow but later loads are fast. Give two likely causes.],
))


#interview-round(3, "Why is the first load slow?",
  "A user in Mumbai says the first load of the tool-detail page takes about 2 seconds, but later loads are fast. Your servers are in one European region. Walk me through the request path and how you would cut the delay.",
  clarify: 3,
  est-title: "Count the round trips (assume a 120 ms round trip)",
  est-cols: ("Step", "Round trips x 120 ms (DNS: given)", "Time"),
  est-rows: ("DNS lookup (nearby resolver, assume 30 ms)", "TCP handshake", "TLS 1.3 handshake", "HTTP request + first byte", "Cold total", "Warm (connection reused)"),
  row-h: 4.4mm,
  sketch-h: 44mm, trade-rows: 2,
  twist: "After you add a load balancer with a database-backed health check, a 30-second database slowdown takes the whole site down. Why, and what do you change?")
