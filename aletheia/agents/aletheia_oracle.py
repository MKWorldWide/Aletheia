"""LLM orchestration agent."""
from __future__ import annotations


class AletheiaOracle:
    """Simplified interface to an LLM for truth synthesis."""

    def generate_response(self, prompt: str) -> str:
        """Return a canned response for now."""
        return f"Oracle says: {prompt}"
