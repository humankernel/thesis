# 🎓 Undergraduate Thesis

This repository contains the materials related to my undergraduate thesis.

* 📂 **Code:** [gh/rag](https://github.com/humankernel/rag)
* 📘 **Thesis Document (PDF):** [gh/main.pdf](https://humankernel.github.io/thesis/main.pdf)
* 🖥️ **Slides:** [gh/thesis-slides](https://github.com/humankernel/thesis-slides)

## 🧠 Overview

This thesis presents an **open-source tool** that leverages **Large Language Models (LLMs)** and **Retrieval-Augmented Generation (RAG)** to enable the **semi-automatic analysis of scientific articles**, tailored to **Cuba’s technological and linguistic context**.

Developed under the **Extreme Programming (XP)** methodology, the system addresses challenges such as **low connectivity**, **geopolitical restrictions**, and **limited computational resources**.
The solution is implemented using **Python**, **vLLM**, and **Gradio**, and integrates models such as:

* 🧩 `DeepSeek-R1-Distill-Qwen-1.5B`
* 🧠 `BAAI/bge-m3`

The tool features modules for **query reformulation**, **document retrieval**, and **answer generation**.
Automated evaluations using **RAGAS** metrics produced **encouraging results**, confirming the system’s **technical feasibility** and establishing a foundation for **future research and improvements**.

## ⚙️ Building the Thesis PDF

To compile the thesis document into a `.pdf`, you’ll need [**Typst**](https://typst.app/).

Once installed, run:

```bash
typst compile main.typ
```

This will generate the final `main.pdf` file.