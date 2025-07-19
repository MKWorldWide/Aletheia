"""Very small symbolic logic engine."""
from __future__ import annotations


class LogicEngine:
    """Evaluate the truthiness of statements using simple rules."""

    def evaluate(self, statement: str) -> bool:
        """Return True for non-empty statements ending with a period."""
        return bool(statement and statement.strip().endswith("."))
