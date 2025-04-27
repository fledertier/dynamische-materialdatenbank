enum Models {
  /// The standard model we recommend. It is the most lightweight with the fastest performance and good results across all benchmarks. It is sufficient for general conversations and assistance.
  llama8b("meta-llama-3.1-8b-instruct", [Capabilities.text]),

  /// Variant of [llama8b] with RAG.
  llama8bRag("meta-llama-3.1-8b-rag", [Capabilities.text, Capabilities.arcana]),

  /// SauerkrautLM is trained by VAGOsolutions on Llama 3.1 70B specifically for prompts in German.
  sauerkraut70b("llama-3.1-sauerkrautlm-70b-instruct", [
    Capabilities.text,
    Capabilities.arcana,
  ]),

  /// Achieves good overall performance, on par with GPT-4, but with a much larger context window and more recent knowledge cutoff. Best in English comprehension and further linguistic reasoning, such as translations, understanding dialects, slang, colloquialism and creative writing.
  llama70b("llama-3.3-70b-instruct", [Capabilities.text]),

  /// Llama 4 Scout and Maverick are the most recent models released by Meta. They utilize a mixture-of-experts (MoE) architecture for better comprehension and incorporate early fusion for native multimodality. Llama 4 Scout has 17B parameters with 16 experts. As a result, it is useful for general conversations, as well as image reasoning and captioning.
  scout17b("llama-4-scout-17b-16e-instruct", [
    Capabilities.text,
    Capabilities.image,
  ]),

  /// Gemma is Google’s family of light, open-weights models developed with the same research used in the development of its commercial Gemini model series. Gemma 3 27B Instruct is quite fast and thanks to its support for vision (image input), it is a great choice for all sorts of conversations.
  gemma27b("gemma-3-27b-it", [Capabilities.text, Capabilities.image]),

  /// Developed by Mistral AI, Mistral Large Instruct 2407 is a dense language model with 123B parameters. It achieves great benchmarking scores in general performance, code and reasoning, and instruction following. It is also multi-lingual and supports many European and Asian languages.
  mistral("mistral-large-instruct", [Capabilities.text]),

  /// Lightweight version of [mistral].
  mistral7b("e5-mistral-7b-instruct", [Capabilities.embeddings]),

  /// Built by Alibaba Cloud, Qwen 2.5 72B Instruct is another large model with benchmark scores slightly higher than Mistral Large Instruct. Qwen is trained on more recent data, and is thus also better suited for global affairs. It is great for multilingual prompts, but it also has remarkable performance in mathematics and logic.
  qwen72b("qwen-2.5-72b-instruct", [Capabilities.text]),

  /// Qwen 2.5 Coder 32B Instruct is a code-specific LLM based on Qwen 2.5. It has one of the highest scores on code-related tasks, on par with OpenAI’s GPT-4o, and is recommended for code generation, code reasoning and code fixing.
  qwenCoder32b("qwen2.5-coder-32b-instruct", [
    Capabilities.text,
    Capabilities.code,
  ]),

  /// Codestral 22B was developed by Mistral AI specifically for the goal of code completion. It was trained on more than 80 different programming languages, including Python, SQL, bash, C++, Java, and PHP. It uses a context window of 32k for evaluation of large code generating, and can fit on one GPU of our cluster.
  codestral22b("codestral-22b", [Capabilities.text, Capabilities.code]),

  /// A lightweight, fast and powerful Vision Language Model (VLM), developed by OpenGVLab. It builds upon InternVL2.5 8B and Mixed Preference Optimization (MPO).
  internvl8b("internvl2.5-8b", [Capabilities.text, Capabilities.image]),

  /// A powerful Vision Language Model (VLM) with competitive performance in both langauge and image comprehension tasks.
  qwenVl72b("qwen-2.5-vl-72b-instruct", [
    Capabilities.text,
    Capabilities.image,
  ]),

  /// Developed by Alibaba Cloud, QwQ is the reasoning model of the Qwen series of LLMs. Compared to non-reasoning Qwen models, it achieves significnatly higher performance in tasks that require problem-solving. QwQ 32B is lighter and faster than DeepSeek R1 and OpenAI’s o1, but achieves comparable performance.
  qwq32b("qwq-32b", [Capabilities.reasoning]),

  /// Developed by the Chinese company DeepSeek, DeepSeek R1 is the first highly-capable open-weights reasoning model ever to be released. Although very large and quite slow, it achieves one of the best overall performances among open models, on par with OpenAI’s GPT-4o or even o1.
  deepseek("deepseek-r1", [Capabilities.reasoning]);

  final String model;
  final List<Capabilities> capabilities;

  const Models(this.model, this.capabilities);
}

enum Capabilities { text, image, code, arcana, reasoning, embeddings }
