"""FastAPI interface for Aletheia."""
from __future__ import annotations

from fastapi import FastAPI

from aletheia.core.inference import TruthInferenceEngine


app = FastAPI()
engine = TruthInferenceEngine()


@app.get("/evaluate")
def evaluate(statement: str) -> dict:
    """Expose a simple evaluation endpoint."""
    return {"truth": engine.evaluate(statement)}
