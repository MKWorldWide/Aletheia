"""Symbol table for storing named values."""
from __future__ import annotations

from dataclasses import dataclass


@dataclass
class Symbol:
    """Simple key/value symbol."""

    name: str
    value: str


class SymbolTable:
    """Registry of symbols used by the logic engine."""

    def __init__(self) -> None:
        self._symbols: dict[str, Symbol] = {}

    def add(self, name: str, value: str) -> None:
        """Add a symbol to the table."""
        self._symbols[name] = Symbol(name, value)

    def get(self, name: str) -> str | None:
        """Retrieve a symbol value by name."""
        symbol = self._symbols.get(name)
        return symbol.value if symbol else None
