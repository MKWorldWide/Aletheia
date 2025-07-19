"""Simple truth inference engine."""
from __future__ import annotations

from .logic_engine import LogicEngine


class TruthInferenceEngine:
    """Evaluate statements using the underlying logic engine."""

    def __init__(self) -> None:
        self.logic = LogicEngine()

    def evaluate(self, statement: str) -> bool:
        """Return True if the logic engine deems the statement valid."""
        return self.logic.evaluate(statement)
