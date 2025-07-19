"""Detect the truthfulness of statements."""
from __future__ import annotations


class TruthDetector:
    """Placeholder truth detector."""

    def detect(self, statement: str) -> bool:
        """Pretend to detect truth using naive heuristics."""
        return statement.lower() not in {"lie", "false"}
