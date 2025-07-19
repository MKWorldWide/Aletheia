"""Streamlit dashboard placeholder."""
from __future__ import annotations

import streamlit as st

from aletheia.core.inference import TruthInferenceEngine


engine = TruthInferenceEngine()


st.title("Aletheia Dashboard")
statement = st.text_input("Statement")
if st.button("Evaluate"):
    result = engine.evaluate(statement)
    st.write(f"Truth: {result}")
