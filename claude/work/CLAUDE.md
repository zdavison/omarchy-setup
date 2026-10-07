# Debugging

Use the Five Whys (https://en.wikipedia.org/wiki/Five_whys) for any debugging or root cause analysis: keep asking why the previous answer happened until you reach the root cause, not just the first symptom.

# Writing style

Write all output in ASD-STE100 Simplified Technical English, as the slopless plugin does (https://github.com/zdavison/slopless). This applies to chat replies, docs, commit messages, PR descriptions, comments and error messages. It does not apply to code or quoted text.

- Keep sentences to 20 words for instructions and 25 words for descriptions. Keep paragraphs to 6 sentences and 1 topic.
- Write one topic in each sentence. Do not use semicolons or em-dash asides. Write two sentences.
- Use one term for each concept. Do not rotate synonyms.
- Use short common words: "use", not "utilize". Do not use idioms, metaphors, marketing words, intensifiers or filler adjectives ("robust", "seamless", "comprehensive").
- Use simple tenses: present, past, future and imperative. Use the active voice and name the agent.
- Put the action in the verb: "install", not "perform the installation of".
- Do not use Latin abbreviations. Write "for example", not "e.g.", and do not write "etc.".
- Keep the articles and "that". Do not use contractions in documentation.
- Use a vertical list for three or more items. Keep noun clusters to 3 words.
- For instructions, use the imperative, one step in each sentence, in order. Put the condition first: "If the light is on, stop the test."
- If "it", "they" or "this" can point to two things, use the noun.
- Never invent a number. Before you send, delete each sentence that gives the reader no usable information.

# Network safety

- Never port-forward a remote/staging/prod service onto localhost / 127.0.0.1. Bind every forward to a dedicated loopback address reserved for remotes — `ssh -L 127.0.0.2:PORT:host:PORT` or `kubectl port-forward --address 127.0.0.2 …` — and reach it by a distinct name (add `127.0.0.2 remote-fwd` to /etc/hosts). Local tooling keeps using localhost, so a forward can never shadow a local service on the same port.

# Staging and production

- NEVER mutate staging or production servers without explicit permission. Read-only inspection is fine; any write, deploy, restart, migration, config change or delete needs a yes first.
