# Sources and licences

Rules: cite every borrowed fact; re-express in our own words; redraw figures; quote at most a short phrase
with attribution. "Cite only" means link and cite, never copy text or figures.

Link check run on 2026-11-27 (each URL fetched). "Licence seen" is what the page itself shows; absence of a
licence line means all rights reserved by default, not that reuse is allowed.

| Ch | Source | URL (verified) | Licence seen | Use |
|---|---|---|---|---|
| 1, 2 | Jones, Wilkes, Murphy (with Smith), "Service Level Objectives", ch. 4, *Site Reliability Engineering* (Google / O'Reilly, web edition © 2017) | https://sre.google/sre-book/service-level-objectives/ | CC BY-NC-ND 4.0 (footer) | Cite only |
| 2 | Peter Norvig, "Teach Yourself Programming in Ten Years" (answers section lists approximate operation timings; page © 2001-2014) | https://norvig.com/21-days.html | Copyright notice only | Cite only; our numbers are our own "working values" |
| 2 | Interactive "Latency Numbers Every Programmer Should Know" by year (author not named on the page; derives from Norvig's numbers) | https://colin-scott.github.io/personal_website/research/interactive_latency.html | None shown | Cite only |
| 3, 5 | IETF RFC 9110, 9111, 9113, 9114 (2022), RFC 9000 (2021), RFC 8446 (2018) | https://www.rfc-editor.org/rfc/rfcNNNN.html | © IETF Trust; code components BSD (RFC 9113: none visible) | Cite; check notice before reusing text |
| 3 | IETF RFC 1035, "Domain Names: Implementation and Specification" (1987) | https://www.rfc-editor.org/rfc/rfc1035.html | No notice on page ("Distribution of this memo is unlimited") | Cite |
| 4 | DeCandia et al., "Dynamo", SOSP 2007 | https://www.allthingsdistributed.com/2007/10/amazons_dynamo.html | ACM copyright; author's version, not for redistribution | Cite only |
| 4 | Chang et al., "Bigtable", OSDI 2006, pp. 205-218 | https://research.google/pubs/bigtable-a-distributed-storage-system-for-structured-data/ | None shown | Cite only |
| 4 | Corbett et al., "Spanner", OSDI 2012 | https://research.google/pubs/pub39966/ | None shown | Cite only |
| 5 | Nishtala et al., "Scaling Memcache at Facebook", NSDI 2013, pp. 385-398 | https://www.usenix.org/conference/nsdi13/technical-sessions/presentation/nishtala | USENIX open access to the PDF; no CC licence line | Cite only |
| 6 | Kreps, Narkhede, Rao, "Kafka: a Distributed Messaging System for Log Processing", NetDB 2011 | No authoritative URL verified (only unofficial university copies) | Unknown | Cite only; find the ACM or NetDB page before print |
| 6 | "Timeouts, retries, and backoff with jitter", AWS Builders' Library (Dec 2019; old URL redirects) | https://builder.aws.com/content/3EumjoZascWd1oZiEgL8ORlv3qE/timeouts-retries-and-backoff-with-jitter | © Amazon Web Services; no reuse licence | Cite only |

Reserved for later parts (page verified, not yet used):

| Source | URL | Licence seen |
|---|---|---|
| Ongaro and Ousterhout, "In Search of an Understandable Consensus Algorithm", USENIX ATC 2014 | https://www.usenix.org/conference/atc14/technical-sessions/presentation/ongaro | USENIX open access; no CC line (the Raft talk slides are CC BY 4.0 per earlier search) |

Sentiment evidence (Blind, Hacker News, LinkedIn) is anecdotal and recorded in `PHASE1-research-and-proposal.md`.
Reddit could not be searched with our tooling and remains unchecked.

## Content claims checked against the paper text (2026-11-27)

- Dynamo (SOSP 2007): states "R + W > N yields a quorum-like system", with N, R, W as configurable parameters. Used in Ch 4.
- Scaling Memcache (NSDI 2013): section 3.2.1 introduces *leases* "to address two problems: stale sets and thundering herds"; regions and a master region for replication are described. Used in Ch 5.
- Not independently checked: that the Kafka paper is "a good origin story for the log model" (Ch 6, a soft claim), and the latency-ladder figures, which are our own rounded working values informed by, not copied from, Norvig's list.
