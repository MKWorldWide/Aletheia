"""Simple Streamlit dashboard for Aletheia."""

from __future__ import annotations

import streamlit as st

from aletheia.core.inference import TruthInferenceEngine
from aletheia.agents.aletheia_oracle import AletheiaOracle


engine = TruthInferenceEngine()
oracle = AletheiaOracle()


st.title("Aletheia Dashboard")

tab_eval, tab_oracle = st.tabs(["Evaluate", "Ask Oracle"])

with tab_eval:
    statement = st.text_input("Statement", key="statement")
    if st.button("Evaluate"):
        result = engine.evaluate(statement)
        st.write(f"Truth: {result}")

with tab_oracle:
    question = st.text_input("Question", key="question")
    if st.button("Ask"):
        response = oracle.generate_response(question)
        st.write(response)
