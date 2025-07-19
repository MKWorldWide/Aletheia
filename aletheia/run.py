"""Entry point for running a minimal Aletheia API."""
from fastapi import FastAPI
from aletheia.core.inference import TruthInferenceEngine

app = FastAPI(title="Aletheia")
engine = TruthInferenceEngine()


@app.get("/truth")
def get_truth(statement: str) -> dict:
    """Evaluate a statement and return the result."""
    result = engine.evaluate(statement)
    return {"statement": statement, "truth": result}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
