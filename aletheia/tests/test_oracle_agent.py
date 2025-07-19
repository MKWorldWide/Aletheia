"""Tests for the oracle agent."""
from aletheia.agents.aletheia_oracle import AletheiaOracle


def test_oracle_response() -> None:
    oracle = AletheiaOracle()
    response = oracle.generate_response("test")
    assert "Oracle says:" in response
