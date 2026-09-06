tweet drafts: agent fleets need recovery loops

— one-liner —
1a. an agent fleet without recovery is just parallel failure
1b. running five agents is easy. knowing which one quietly died is the product

— two-punch —
2a. concurrency makes an agent fleet look autonomous. recovery is what makes it real
2b. the demo is five agents running at once. the production test is one getting stuck at 3am and the fleet knowing what to do next

— paragraph —
3a. agent fleets do not fail like chatbots. one chain gets stuck, another keeps reporting green, and the work looks alive from a distance. health, receipts and recovery paths are part of the product
3b. everyone wants more agents running in parallel. i want the boring layer too: which run owns the task, where it stopped, what already shipped, and whether retrying will duplicate the action

— long tweet —
4a. had a dev loop stay dispatched for more than 24 hours while the rest of the fleet kept moving. this is the part of agent infrastructure the demos skip. concurrency is useful, but without health checks, durable receipts and a safe recovery path you have not built autonomy. you have built more places for work to disappear
4b. the hardest part of running an agent fleet is not starting five harnesses. it is knowing when one quietly stopped, whether another agent already completed the work, and if a retry will send the same email or open the same PR twice. orchestration gets the screenshots. recovery earns the trust

— thread opener —
5a. one of my agent chains stayed dispatched for 24+ hours while the rest of the fleet kept working. looked busy, was stuck. a small breakdown of what agent autonomy actually needs
5b. running agents across multiple harnesses taught me this: portability gets them started, receipts tell you what happened, recovery keeps the fleet useful. the third part is where most systems are still weak

best: #4b — turns a concrete fleet failure into the clearest production lesson
