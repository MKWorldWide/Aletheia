"""Very small symbolic logic engine."""

from __future__ import annotations


from .symbol_table import SymbolTable


class LogicEngine:
    """Evaluate the truthiness of statements using a symbol table."""

    def __init__(self) -> None:
        self.symbols = SymbolTable()

    def add_fact(self, subject: str, obj: str) -> None:
        """Record a true statement of the form `subject is obj`."""
        self.symbols.add(subject.lower(), obj.lower())

    def evaluate(self, statement: str) -> bool:
        """Return True if the statement matches a known fact."""
        if not statement:
            return False

        normalized = statement.strip().lower()
        if not normalized.endswith("."):
            return False
        normalized = normalized[:-1].strip()

        if " is not " in normalized:
            subj, obj = normalized.split(" is not ", 1)
            return not self.symbols.has(subj.strip(), obj.strip())
        if " is " in normalized:
            subj, obj = normalized.split(" is ", 1)
            return self.symbols.has(subj.strip(), obj.strip())

        return False
