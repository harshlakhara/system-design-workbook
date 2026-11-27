#import "../../lib.typ": *

= Primary sources for Part I

Read the originals; do not rely on our summaries. Licence notes come from what each page showed on 27 Nov 2026 (see `SOURCES.md`). Most items are *cite only*: we link and cite them but never copy text or figures.

== Chapter 1. Thinking in systems

- Jones, Wilkes and Murphy (with Smith), "Service Level Objectives", chapter 4 of _Site Reliability Engineering_, ed. Beyer et al. (Google and O'Reilly Media; web edition © 2017). https://sre.google/sre-book/service-level-objectives/ . Licensed CC BY-NC-ND 4.0, so we cite it and do not copy it.

== Chapter 2. Numbers you should feel

- Peter Norvig, "Teach Yourself Programming in Ten Years", answers section: https://norvig.com/21-days.html . Interactive year-by-year version: https://colin-scott.github.io/personal_website/research/interactive_latency.html . The original list dates from the early 2000s; quote none of it and check current figures yourself.
- Google SRE book, "Service Level Objectives" (ch. 4), for the language of availability targets: https://sre.google/sre-book/service-level-objectives/ (CC BY-NC-ND 4.0; cite only).

== Chapter 3. The life of a request

- IETF RFC 9110 "HTTP Semantics" (2022), RFC 9111 "HTTP Caching" (2022), RFC 9113 "HTTP/2" (2022), RFC 9114 "HTTP/3" (2022), RFC 9000 "QUIC: A UDP-Based Multiplexed and Secure Transport" (2021), RFC 8446 "The Transport Layer Security (TLS) Protocol Version 1.3" (2018), RFC 1035 "Domain Names: Implementation and Specification" (1987). Each is at https://www.rfc-editor.org/rfc/rfcNNNN.html with the number substituted. Most carry an IETF Trust copyright notice (code components under BSD); RFC 1035 shows none. Check the notice before reusing any text.

== Chapter 4. Choosing where data lives

- DeCandia et al., "Dynamo: Amazon's Highly Available Key-value Store", SOSP 2007. ACM copyright (the blog notes it is the author's version, not for redistribution). Read via the authors' blog post: https://www.allthingsdistributed.com/2007/10/amazons_dynamo.html . Cite and link; do not copy figures.
- Chang et al., "Bigtable: A Distributed Storage System for Structured Data", OSDI 2006, pp. 205-218. https://research.google/pubs/bigtable-a-distributed-storage-system-for-structured-data/
- Corbett et al., "Spanner: Google's Globally-Distributed Database", OSDI 2012. https://research.google/pubs/pub39966/

== Chapter 5. Caching

- Nishtala et al., "Scaling Memcache at Facebook", NSDI 2013, pp. 385-398 (open access via USENIX): https://www.usenix.org/conference/nsdi13/technical-sessions/presentation/nishtala
- IETF RFC 9111 "HTTP Caching" (2022): https://www.rfc-editor.org/rfc/rfc9111.html

== Chapter 6. Asynchrony

- Kreps, Narkhede, Rao, "Kafka: a Distributed Messaging System for Log Processing", NetDB 2011 (LinkedIn). No authoritative publisher URL was verified; unofficial copies exist on university course sites. Cite only.
- "Timeouts, retries, and backoff with jitter", AWS Builders' Library (2019): https://builder.aws.com/content/3EumjoZascWd1oZiEgL8ORlv3qE/timeouts-retries-and-backoff-with-jitter . Free to read; AWS asserts copyright and states no reuse licence, so cite only.
