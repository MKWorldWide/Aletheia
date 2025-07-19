"""Simple in-memory index for conversation history."""
from __future__ import annotations

from typing import List


class MemoryIndex:
    """Stores conversational snippets for later retrieval."""

    def __init__(self) -> None:
        self._history: List[str] = []

    def add(self, item: str) -> None:
        """Add a conversation item."""
        self._history.append(item)

    def search(self, query: str) -> list[str]:
        """Return items containing the query."""
        return [h for h in self._history if query in h]
