"""Agent responsible for storing and retrieving memories."""
from __future__ import annotations


class MemoryWeaver:
    """Simple in-memory storage manager."""

    def __init__(self) -> None:
        self._store: list[str] = []

    def remember(self, item: str) -> None:
        """Add an item to memory."""
        self._store.append(item)

    def recall(self) -> list[str]:
        """Return all stored items."""
        return list(self._store)
