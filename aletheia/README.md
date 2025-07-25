# Aletheia Scaffold

This directory contains the initial scaffold for **Aletheia**, a research framework for multimodal truth evaluation.  The
structure is intentionally minimal so it can evolve over time.  Each module includes a lightweight implementation to act as a starting point for experiments.

```
aletheia/
├── core/        # Core logic for reasoning and truth evaluation
├── agents/      # Modular cognitive agents (LLM, visual, audio, etc.)
├── memory/      # Local vector or in-memory knowledge base
├── data/        # Prompts, sample data and truth sets
├── interface/   # API endpoints or user interface
├── config/      # Configuration files
├── tests/       # Unit tests
```

3vszgw-codex/generate-aletheia-repo-scaffold
Run `python run.py` to start a demo API with three endpoints:

* `/truth` - evaluate a statement against stored facts.
* `/ask` - query the oracle (uses OpenAI if `OPENAI_API_KEY` is set).
* `/fact` - register a new fact via POST parameters `subject` and `obj`.

The Streamlit dashboard can be started with `streamlit run aletheia/interface/dashboard.py`.

The symbolic engine supports recording simple facts:

```python
from aletheia.core.inference import TruthInferenceEngine

engine = TruthInferenceEngine()
engine.add_fact("sky", "blue")
engine.evaluate("sky is blue.")  # -> True
engine.evaluate("sky is green.")  # -> False
```
