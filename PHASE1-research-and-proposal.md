# System Design Workbook: Phase 1 Research & Proposal

Status: draft for review. No chapter content has been written yet.

## 0. How much to trust this document

Read this first, because it limits what the rest can claim.

- **Evidence from this session:** three web searches. They returned mostly vendor or affiliate blog posts (DesignGurus, Educative, Javarevisited, DEV.to) and a handful of Blind threads. They returned **almost no Reddit threads** and no LinkedIn data.
- **Evidence from my own background knowledge:** the descriptions of what each resource contains. These are accurate to my knowledge but were not re-verified this session. Prices, page counts and star counts change, so re-check before publishing.
- **What I did not do:** read Reddit, Blind or LinkedIn threads in depth. "Community sentiment" below is therefore a **hypothesis table**, marked by confidence. Before Phase 2 we should spend a short, dedicated pass (30–60 threads) to confirm it.
- **Bias warning:** most "best resources" listicles are written by the vendors being ranked. I discounted them.

> **Update:** a verification pass has been run; see section 9 for results. Reddit could not be searched (blocked for our search tool), so Reddit sentiment remains unverified. Blind, Hacker News and LinkedIn were checked.

## 1. The landscape: what people actually use

| Resource | Type / cost | What it does well | Where it falls short (for our purpose) | Confidence in the sentiment |
|---|---|---|---|---|
| **Designing Data-Intensive Applications** (Kleppmann) | Book, paid | The deepest treatment of replication, partitioning, transactions, consistency, stream/batch. Universally treated as the reference. | Not interview-shaped. Dense for freshers. No exercises to speak of. Quickly becomes shelfware. | High (consistent across sources) |
| **System Design Primer** (donnemartin, GitHub) | Free repo | Huge breadth, Anki cards, a free on-ramp. Roughly 375k+ stars per aggregator snapshots. | Link-heavy and shallow in places. Aging. Its license is a **custom one, not a standard open license** — we must not copy from it. No worked capacity math. | High on popularity, medium on quality complaints |
| **Alex Xu, System Design Interview Vol 1 & 2 / ByteByteGo** | Books + subscription | Step-by-step "interview framework", clean diagrams, many classic case studies. | Case studies read as recipes. Each design is presented as "the" answer, with limited trade-off argument. Estimation is shown, not practised. | Medium |
| **Grokking the System Design Interview** (DesignGurus; Educative has a different "Modern" course) | Paid course | Beginner-friendly, interview-question-by-question. | Cited as a strong foundation but weaker on production-level depth. Widely marketed, so reviews are unreliable. Two similarly named products cause confusion. | Medium-low (heavily vendor-written reviews) |
| **Hello Interview** | Paid/free site | Praised on Blind for tighter explanations and a progression of difficulty. Delivery-framework focus. | At least one Blind commenter dismissed it as poor value and claimed AI-generated content; **unverified**. Interview-centric. | Low (a few anecdotes) |
| **Engineering blogs** (Netflix, Uber, Meta, Discord, Stripe, Cloudflare, etc.) | Free | Real numbers and real failures. The best source of senior-level trade-offs. | Scattered, no progression, assume context, no exercises. | High (well-known) |
| **Original papers** (Dynamo, Bigtable, Spanner, Raft, Kafka, Google File System, MapReduce) | Free | Primary sources for core ideas. | Hard for freshers. No guidance on what matters. | High |
| **Mock-interview platforms / peers** | Paid/free | Feedback on live performance. | Not a learning medium; cannot be printed. | High |
| **YouTube channels** | Free | Accessible walkthroughs. | The exact distraction problem you named. Passive. | High |

**Commonly suggested combination in the sources:** a structured course + DDIA as reference + mock interviews. That is the baseline we need to beat with a single offline artifact.

## 2. Community sentiment: hypotheses to verify

| Claim | Basis | Confidence |
|---|---|---|
| People feel overwhelmed by *where to start* and what depth is expected at their level. | Recurring theme in prep threads and in my background knowledge | Medium |
| Paid courses are seen as either "great for structure" or "overpriced repackaging of free content". | Blind threads seen this session; mixed, anecdotal | Medium |
| DDIA is respected but abandoned halfway. | Background knowledge | Medium |
| Candidates memorise architectures ("design X = draw these 6 boxes") and fail when interviewers change a constraint. | Background knowledge; common interviewer complaint | Medium-high |
| Back-of-envelope estimation is the most commonly skipped or fumbled step. | Background knowledge | Medium |
| Seniors complain that most material stops at the "boxes and arrows" level and never reaches failure modes, migration, cost and operations. | Background knowledge | Medium |

**To do before Phase 2:** targeted read of r/cscareerquestions, r/ExperiencedDevs, r/leetcode, Blind system-design tags, and LinkedIn posts, tallying actual complaints. I recommend a small structured pass rather than relying on this table.

## 3. Gaps the workbook should fill

1. **No active recall on paper.** Almost every resource is read-only. The learning happens when you reproduce and defend a design from a blank page.
2. **Estimation is demonstrated, not drilled.** Learners need a reusable table, reference numbers, and many small exercises with check-yourself answers.
3. **Trade-offs are stated as conclusions** ("use Cassandra") rather than as decisions with conditions ("choose X when write rate > Y and you can tolerate Z").
4. **Depth is not labelled.** Freshers and staff engineers get the same page. We tier every section.
5. **Failure and operations are an afterthought.** Few resources ask: what breaks first, how do you know, how do you roll back?
6. **Recipes over reasoning.** Case studies teach one answer. We should teach the *derivation*, then vary the constraints.
7. **Screen dependence.** Nothing is designed for printing: diagrams relying on colour, links as the main content, no writing space.
8. **Licensing.** The best free material is under custom or restrictive terms, so the community cannot remix it. An openly licensed workbook is itself a gap.

## 4. Principles for original content (IP safety)

**Decision (from the project owner): publicly available white papers, tech blogs and similar primary sources are fair game as source material.** "Publicly readable" is not the same as "freely copyable", so the working rules are:

- **Use freely:** facts, numbers, architectures, lessons learned and failure stories from papers, engineering blogs, post-mortems and RFCs. Ideas and facts are not copyrightable; our explanation, structure and exercises are the original IP.
- **Always cite:** every borrowed fact or figure gets an inline citation (author, org, year, URL) and an entry in the chapter's "Primary sources" box. Include an archive link (e.g. web.archive.org) because blog URLs rot.
- **Re-express, don't transcribe:** explain in our own words and redraw diagrams ourselves. Do not copy figures, tables or long passages. Quote at most a short phrase, in quotation marks, with attribution.
- **Check the licence per source:** many papers are free to read but copyrighted; some blogs and specs are CC-licensed or openly licensed (RFCs, some vendor docs), which may permit reuse with attribution. Record the licence in `SOURCES.md`; only reuse a figure verbatim if its licence allows and it is compatible with ours.
- **Dated numbers:** label every real-world number with its year and source ("as reported in 2019"), since systems change.
- **Still original:** our case studies use fictional products and constraints, and our worksheets, exercises, derivations and trade-off grids are written from scratch. Real systems appear as short "How it was done in the wild" comparison boxes (◆ tier), each tied to a cited source.
- **Do not copy from books, paid courses or restrictively licensed repos** (including the System Design Primer's custom licence). Public primary sources are the substitute for them.
- Keep a `SOURCES.md` listing, per chapter, the sources used, their licence and access date.
- **Licence proposal:** text and figures **CC BY-SA 4.0** (keeps derivatives open); any build scripts/templates **MIT**. Please confirm: CC BY 4.0 is the more permissive alternative if you want commercial reuse without share-alike.

### 4a. Candidate primary-source map (from background knowledge; verify each URL and licence before use)

| Chapter area | Candidate public sources |
|---|---|
| Replication, partitioning, KV stores (Ch 4, 7) | Dynamo paper (Amazon, 2007); Bigtable (Google, 2006); Cassandra and DynamoDB design write-ups |
| Consensus, coordination (Ch 13) | Raft paper (Ongaro & Ousterhout) and its public site; Paxos Made Simple; Chubby paper; ZooKeeper paper |
| Consistency, time, multi-region (Ch 8, 14) | Spanner (Google, 2012); Jepsen analyses; CAP/PACELC original papers |
| Storage, batch, streaming (Ch 4, 15) | GFS, MapReduce, Kafka papers; LSM-tree and log-structured literature |
| Caching, edge, scale stories (Ch 5, 3) | Facebook "Scaling Memcache" paper; Cloudflare and Netflix engineering blogs |
| Reliability and operations (Ch 11, 12, 18) | Google SRE book (free online); public post-mortems (cloud providers, GitHub, Cloudflare); AWS Builders' Library |
| Cost, capacity (Ch 2, 17) | Public cloud pricing pages and published latency-number lists; "Latency Numbers Every Programmer Should Know" lineage (dated) |
| Protocols and APIs (Ch 3, 10) | IETF RFCs (HTTP, TLS, DNS) |

Per chapter: **3–6 primary sources**, each with a one-line "read this for…" note and a tier tag (● mostly blogs and RFC summaries; ◆ papers and post-mortems).

## 5. Tier markers (print-friendly, no colour dependency)

Each section carries a shape marker so it survives black-and-white printing:

- ● **Foundational** (filled circle): read everything.
- ◐ **Mid-Level** (half circle): read after finishing the ●.
- ◆ **Senior+** (diamond): trade-offs, edge cases, failure modes, operations.

Each chapter opens with a "**Reading paths**" strip: *Fresher: ● only. Mid: ● ◐. Senior: skim ●, deep-read ◐ ◆.*

## 6. Proposed table of contents

**Front matter**
- How to use this workbook (three reading paths, a 6-week and 12-week plan, pencil/pen advice)
- Licence, contribution guide, how to print (A4/Letter, duplex, binding margin)
- The "Blank-Page Method": predict → sketch → reveal → critique

**Part I: Foundations (●)**
1. Thinking in systems: requirements, constraints, and the vocabulary of trade-offs
2. Numbers every engineer should feel: latency, throughput, storage, cost (+ estimation drills)
3. Networking and request lifecycle: DNS, TCP/TLS, HTTP, load balancers, proxies, CDNs
4. Data storage basics: relational vs key-value vs document vs column vs graph vs object store
5. Caching: where, what, how it fails
6. Asynchrony: queues, streams, and pub/sub

**Part II: Scaling and correctness (● ◐)**
7. Replication and partitioning
8. Consistency, ordering, and time (from "what is a transaction" to CAP and PACELC in context)
9. Indexes, search, and data modelling for access patterns
10. APIs, idempotency, pagination, versioning, rate limiting
11. Reliability: timeouts, retries, backpressure, circuit breakers, graceful degradation
12. Observability: metrics, logs, traces, SLOs and error budgets

**Part III: Advanced trade-offs (◐ ◆)**
13. Distributed coordination: leader election, consensus in practice, locks, leases
14. Multi-region design, data residency and disaster recovery
15. Batch, stream, and the data platform
16. Security and privacy by design
17. Cost, capacity planning, and "how do we evolve this in 3 years"
18. Migrations and deployment: zero-downtime changes, expand/contract, rollbacks

**Part IV: Design studios (all tiers, one fictional system each, with ●/◐/◆ variants)**
19. The studio format and a scoring rubric
20–29. Ten original problems: read-heavy (feed/catalog), write-heavy (telemetry), real-time (chat/presence), media (upload + transcode), geo (nearby search), marketplace (inventory + payments), search/autocomplete, scheduling/notifications, collaborative editing, multi-tenant SaaS platform

**Part V: Practice and review**
30. Interview-style and on-the-job communication: clarifying, structuring, defending
31. A 30-question retrieval set with spaced-repetition schedule
32. Failure-mode drills: "it's 3 a.m., X is slow" scenarios
33. Final mock exam (3 timed problems)

**Back matter**: estimation cheat-sheet (tear-out), glossary, symbol key for diagrams, answer keys and worked solutions, source list.

## 7. Worksheet layout system (superseded in part: see section 8, decision 4)

Page size: A4 and US Letter variants, with a 15 mm inner margin for binding, black-and-white only, line weight ≥ 0.4 pt so it photocopies well.

**Recurring worksheet types** (each is a fixed template reused across chapters, so learners build muscle memory):

| Code | Worksheet | Layout |
|---|---|---|
| **W1** | **Capacity Estimation Table** | Rows: users, requests/s (avg + peak), read:write ratio, payload size, storage/day, storage/5 yr, bandwidth, memory for cache, server count. Columns: *Assumption* · *Calculation* · *Result* · *Sanity check* · *Confidence*. A pre-printed powers-of-ten ruler in the margin. |
| **W2** | **Requirements Split** | Two-column page: functional vs non-functional, with a "numbers I need to ask for" box and an "explicitly out of scope" box. |
| **W3** | **Architecture Canvas** | Dot-grid page, a pre-printed legend of 8 shapes (client, service, store, queue, cache, external, boundary, async arrow), and a "data flow numbers" strip along the bottom. |
| **W4** | **Component Trade-off Grid** | Rows: options (up to 4). Columns: *Fits when…* · *Breaks when…* · *Cost* · *Ops burden* · *Reversibility*. Footer: "My choice and the condition that would change it." |
| **W5** | **Bottleneck Checklist** | Checkboxes per layer (client, edge, app, cache, DB, queue, network, third-party) with "first to saturate?" and "evidence I'd look at". |
| **W6** | **Failure Walk-through** | A timeline: trigger → blast radius → detection → mitigation → recovery → prevention. |
| **W7** | **Data Model & Access Patterns** | Left: entities/keys. Right: list of queries ranked by frequency, with the index each one needs. |
| **W8** | **API Sketch Sheet** | Endpoint table (method, path, idempotent?, auth, pagination) plus an error-case column. |
| **W9** | **Evolution Plan** | Three horizons (now / 10× / 100×), "what changes at each", and migration steps. |
| **W10** | **Retrieval Card Page** | Cut-out grid of Q-only cards with answers printed upside-down at the bottom of the page; a Leitner-box tracker. |
| **W11** | **Reflection Log** | "What I got wrong / why / what I'd check next time." |

**Chapter page rhythm** (so reading never exceeds about 40% of the page count):
1. *Predict* box: answer a question before reading (a blank space).
2. Concept page (≤ 2 pages) with one diagram per idea.
3. *Worked example*: fully done on a filled-in worksheet.
4. *Your turn*: the same worksheet, blank, with a different number set.
5. *Check*: answers at the back, shuffled by chapter to discourage peeking.
6. *Deepen* ◆ sidebar for seniors.

**Studio problem layout (4–6 pages each):** brief (half page) → W2 → W1 → W7 → W3 (two blank canvases: v1 and "after the twist") → W4 → W5/W6 → reference solution with commentary at the back.

## 8. Decisions (locked by the project owner)

1. **Audience:** interview preparation first (including the owner's own prep). On-the-job design is secondary.
2. **Licence:** CC BY-SA 4.0 for text and figures; MIT for tooling and templates.
3. **Toolchain:** Typst. Source lives in `main.typ`, `lib.typ` and `src/`.
4. **Print economy:** no full blank worksheet pages. Worksheets are replaced by compact **Interview Round** templates: the interviewer asks a question, the candidate answers in a fixed five-step structure (clarify, estimate, sketch, defend, adapt to a twist) on one page. This supersedes the full-page worksheet list in section 7 and the "about 40% blank pages" target.
5. **Verification pass:** done (section 9). Reddit remains unchecked.

## 9. Verification pass results

### 9a. Sentiment hypotheses (section 2) after checking Blind, Hacker News, LinkedIn

All evidence is anonymous and anecdotal. None of it measures how common a problem is.

| Hypothesis | Verdict | Evidence |
|---|---|---|
| Candidates memorise designs and fail when constraints change | **Supported** | A Blind commenter says a memorised answer shows when the interviewer asks how the design changes under new requirements; a hiring-side LinkedIn essay says interviewers deliberately change requirements mid-design and weak candidates keep patching. |
| Trade-offs and failure modes matter more than recall | **Supported** | Blind commenters say to study real systems' pros and cons; interviewers report probing what breaks and what the bottleneck is. |
| Reflexive "add a cache / bigger queue" without reasoning | **Supported (new)** | One interviewer describes candidates adding a cache to a write-heavy design without asking why; another says hasty responses like enlarging a full queue made problems worse. |
| Buzzword answers that are generic rather than specific | **Supported (new)** | Interviewers describe candidates listing technologies unrelated to the question. |
| Depth vs breadth miscalibration | **Supported (new)** | One candidate reported failing after being unable to explain how Redis handles concurrency; another describes going too deep on one small component. |
| Seniors give hand-wavy answers on their own systems | **Weakly supported** | A single commenter's claim. |
| DDIA is respected but hard to finish | **Supported** | Hacker News: "too dense", "really dry", some stalled midway; others found it readable. Suggested coping: read selectively, pair with docs, skip some end-of-part chapters. Some say it is "way too deep" for interviews. |
| Estimation is the most commonly fumbled step | **Not verified** | The search returned nothing specific on estimation. Treat as an assumption. |
| Paid courses seen as "great structure" vs "overpriced repackaging" | **Mixed, unverified in depth** | Blind opinions split; reviews are mostly vendor-written. |
| Reddit-specific sentiment | **Not checked** | Reddit is blocked for our search tool. The built-in browser could read threads manually if you want that. |

**Design implications:** the findings strengthen the case for (a) "twist" exercises where constraints change mid-problem (already in the studio format), (b) a W5-style "why am I adding this component?" justification line on every canvas, and (c) a ◆ "justify the depth" prompt. They do not support claiming that estimation is the top pain point, so I removed that as a headline claim.

### 9b. Primary-source licences and availability (section 4a)

Checked from search snippets and one direct page fetch. Treat "no statement found" as "ask before reusing", not as "free".

| Source | What was found | Reuse implication |
|---|---|---|
| **Google SRE book (1st ed.)** | Page footer states **CC BY-NC-ND 4.0** (fetched directly). The 2nd edition page shows no licence statement. | NonCommercial + NoDerivatives. Cite and link only. We must not copy or adapt text or figures into a CC BY-SA workbook. The NC term would also conflict with our commercial-reuse goal. |
| **Raft paper (USENIX ATC '14)** | No licence statement found for the paper. The Raft **talk slides are CC BY 4.0**. | Cite the paper. Slide figures may be reusable with attribution; confirm on the slide repo. |
| **Dynamo paper (SOSP '07)** | ACM copyright; hosted by Amazon's CTO's blog "by permission of ACM for personal use". | Cite and link to the official entry. Do not copy figures. |
| **Spanner paper (OSDI '12)** | Listed on research.google. No reuse licence seen in snippets. | Cite and link. Re-draw our own diagrams. |
| **Kafka paper (NetDB '11)** | ACM notice: personal/classroom copies allowed, not for profit. | Cite and link only. |
| **IETF RFCs** | The IETF Trust provisions license code components under the Revised BSD licence; RFC prose falls under the Trust's own terms (CC BY 4.0 for some categories), depending on the document. | The most reuse-friendly source, but check each RFC's notice. |
| **AWS Builders' Library** | Free to read and reference; AWS site terms assert copyright; no reuse grant found. | Cite and link only. |
| **Jepsen** | Test harness code: Eclipse Public License. No explicit licence found for report text. | Cite and link; ask before quoting. |
| **Scaling Memcache (NSDI '13)** | No result returned. | Locate on usenix.org before listing it. |

**Consequences for our rules:** the "cite + re-express" policy in section 4 holds, and in practice almost every item above is **cite-and-link only**. Verbatim reuse is realistic only for CC BY or similarly licensed material (e.g. the Raft slides, some RFC text). `SOURCES.md` should record the licence next to each source so contributors can see this at a glance. I also recommend we record each source as "**read-only reference**" or "**reusable with attribution**".

## Sources consulted this session

- [Best system design resources in 2026 (Educative)](https://www.educative.io/blog/best-system-design-resources-2026) (vendor)
- [Blind: system design best sources 2026](https://www.teamblind.com/post/system-design-best-sources-2026-2tb428ku)
- [Blind: best interview prep site](https://www.teamblind.com/post/best-interview-prep-site-bjkn7cog)
- [Blind: Is Grokking worth it?](https://www.teamblind.com/post/is-grokking-worth-the-kk0xacwv)
- [Is Grokking the System Design Interview worth it? (Javarevisited)](https://medium.com/javarevisited/review-of-grokking-the-system-design-course-on-educative-is-it-worth-it-b24af8fb326d) (affiliate-style)
- [System Design Primer repo stats (Star History)](https://www.star-history.com/donnemartin/system-design-primer) and [Trendshift](https://trendshift.io/repositories/977) (custom licence noted)
