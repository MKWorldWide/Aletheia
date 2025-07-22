"""Simple truth inference engine."""
from __future__ import annotations

from .logic_engine import LogicEngine

class TruthInferenceEngine:
    """Evaluate statements using the underlying logic engine."""

    def __init__(self) -> None:
        self.logic = LogicEngine()

    def add_fact(self, subject: str, obj: str) -> None:
        """Register a fact with the underlying logic engine."""
        self.logic.add_fact(subject, obj)

    def evaluate(self, statement: str) -> bool:
        """Return True if the logic engine deems the statement valid."""
        return self.logic.evaluate(statement)