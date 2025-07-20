"""Entry point for running a minimal Aletheia API."""

from fastapi import FastAPI
from aletheia.core.inference import TruthInferenceEngine
from aletheia.agents.aletheia_oracle import AletheiaOracle

app = FastAPI(title="Aletheia")
engine = TruthInferenceEngine()
oracle = AletheiaOracle()


@app.get("/truth")
def get_truth(statement: str) -> dict:
    """Evaluate a statement and return the result."""
    result = engine.evaluate(statement)
    return {"statement": statement, "truth": result}


@app.post("/fact")
def add_fact(subject: str, obj: str) -> dict:
    """Record a fact for later truth evaluations."""
    engine.add_fact(subject, obj)
    return {"subject": subject, "object": obj}


@app.get("/ask")
def ask_oracle(question: str) -> dict:
    """Return an oracle-generated answer."""
    answer = oracle.generate_response(question)
    return {"question": question, "answer": answer}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
