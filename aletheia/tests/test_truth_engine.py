"""Tests for the truth inference engine."""

from aletheia.core.inference import TruthInferenceEngine


def test_truth_engine_returns_correct_results() -> None:
    engine = TruthInferenceEngine()
    engine.add_fact("sky", "blue")

    # Evaluate known truths
    assert engine.evaluate("sky is blue.") is True
    assert engine.evaluate("sky is green.") is False
    assert engine.evaluate("sky is not green.") is True
    assert engine.evaluate("sky is not blue.") is False

    # Type safety
    assert isinstance(engine.evaluate("sky is blue."), bool)
    assert isinstance(engine.evaluate(""), bool)