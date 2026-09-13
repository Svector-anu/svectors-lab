tweet drafts: huge models become storage systems

— one-liner —
1a. the next ai hardware flex might just be a really fast ssd
1b. 744b models on consumer hardware changes what local ai even means

— two-punch —
2a. colibri runs a 744b moe across vram, ram and storage. turns out the bottleneck was not model size, it was moving the right experts fast enough
2b. we kept asking how much vram a huge model needs. colibri asks a better question: which tiny part of the model needs to be in vram right now

— paragraph —
3a. a 744b model sounds like datacenter-only infrastructure. colibri streams inactive experts from disk and keeps only the active ones close. huge local models are becoming a systems problem, not just a gpu budget
3b. local ai does not need the whole model sitting in vram. it needs the right weights available at the right moment. vram, ram and storage are starting to look like one inference memory layer

— long tweet —
4a. colibri running a 744b moe on consumer hardware is a useful reframe. the machine does not need every expert loaded at once. it needs to predict which experts will be used, keep the hot ones nearby and stream the rest from disk. once vram, ram and storage become one managed layer, model size stops mapping directly to gpu size. the next local ai breakthrough might look more like an operating system than a new model
4b. everyone compares local ai setups by gpu memory. colibri makes that number less useful. a mixture-of-experts model only activates part of itself for each token, so inactive experts can live on disk while the useful ones move through ram and vram. that turns 744b inference from an impossible allocation into a scheduling problem. fast storage and good orchestration can beat buying enough gpu to hold everything

— thread opener —
5a. colibri is running 744b mixture-of-experts models on consumer hardware by treating vram, ram and storage as one system. this is less about fitting a huge model and more about moving the right experts at the right time
5b. huge local models might not require huge gpus. they might require better scheduling. colibri streams inactive experts from disk, keeps hot weights close and turns 744b inference into a storage orchestration problem

best: #4a — connects the technical mechanism to the bigger local ai shift
