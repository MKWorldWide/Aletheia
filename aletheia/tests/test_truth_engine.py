"""Tests for the truth inference engine."""

from aletheia.core.inference import TruthInferenceEngine


def test_truth_engine_returns_bool() -> None:
    engine = TruthInferenceEngine()
    engine.add_fact("sky", "blue")
    assert engine.evaluate("sky is blue.") is True
    assert engine.evaluate("sky is green.") is False
