"""Tests for the truth inference engine."""
from aletheia.core.inference import TruthInferenceEngine


def test_truth_engine_returns_bool() -> None:
    engine = TruthInferenceEngine()
    assert isinstance(engine.evaluate("Hello."), bool)
