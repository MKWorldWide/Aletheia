"""LLM orchestration agent."""
3vszgw-codex/generate-aletheia-repo-scaffold

from __future__ import annotations

import os


class AletheiaOracle:
    """Interface to an LLM for truth synthesis."""

    def __init__(self, model: str = "gpt-3.5-turbo") -> None:
        self.model = model

    def generate_response(self, prompt: str) -> str:
        """Generate a response using OpenAI if configured."""
        api_key = os.getenv("OPENAI_API_KEY")
        if api_key:
            try:
                import openai

                openai.api_key = api_key
                chat = openai.ChatCompletion.create(
                    model=self.model,
                    messages=[{"role": "user", "content": prompt}],
                )
                return chat["choices"][0]["message"]["content"].strip()
            except Exception:
                pass
