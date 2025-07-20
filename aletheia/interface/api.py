"""FastAPI interface for Aletheia."""
from __future__ import annotations

from fastapi import FastAPI

from aletheia.agents.aletheia_oracle import AletheiaOracle

from aletheia.core.inference import TruthInferenceEngine


app = FastAPI()
engine = TruthInferenceEngine()
oracle = AletheiaOracle()


@app.get("/evaluate")
def evaluate(statement: str) -> dict:
    """Expose a simple evaluation endpoint."""
    return {"truth": engine.evaluate(statement)}


@app.post("/fact")
def add_fact(subject: str, obj: str) -> dict:
    """Record a new fact for future evaluations."""
    engine.add_fact(subject, obj)
    return {"subject": subject, "object": obj}


@app.get("/ask")
def ask(question: str) -> dict:
    """Return an answer from the oracle."""
    return {"answer": oracle.generate_response(question)}
