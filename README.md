# Undergrad Thesis

The project is in ([gh://rag](https://github.com/humankernel/rag)). The document PDF in ([gh://pdf]()) 

The present thesis proposes an open-source tool based on large language models (LLMs) and retrieval-augmented generation (RAG) to facilitate the semi-automatic analysis of scientific articles, adapted to Cuba’s technological and linguistic context. Facing limitations such as low connectivity, geopolitical restrictions, and lack of resources, the solution employs Python, vLLM, and Gradio, using models such as DeepSeek-R1-Distill-Qwen-1.5B and BAAI/bge-m3. Developed under the Extreme Programming (XP) methodology, the tool includes modules for query reformulation, retrieval, and answer generation. Automated evaluations using the metrics defined by RAGAS yielded encouraging results, validating the system’s technical feasibility and laying the groundwork for future improvements.

## Getting Started

To compile the thesis into a `.pdf` you need to have [Typst](https://typst.app/)

```bash
typst compile main.typ
```

