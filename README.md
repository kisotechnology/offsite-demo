# Kiso Offsite Demo

A demo project showcasing how to use evals to build AI products for the Kiso offsite.

## Prerequisites

- [pyenv](https://github.com/pyenv/pyenv) for Python version management
- [uv](https://github.com/astral-sh/uv) for fast Python package management

## Setup

1. Install the required Python version using pyenv:
   ```bash
   pyenv install 3.12.7
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```

3. Install dependencies using uv:
   ```bash
   uv sync
   ```

## Project Structure

- `app_store_reviews/`: Contains the main application code
- `data/`: Data files used by the application
- `pyproject.toml`: Project configuration and dependencies
- `uv.lock`: Lock file for deterministic dependency installation

## Running Evals

The project includes an evaluation system for analyzing app store reviews using Braintrust and BAML. To run the evals:

1. Set up your environment variables:
   ```bash
   cp app_store_reviews/.env.example app_store_reviews/.env
   ```
   Then edit `app_store_reviews/.env` with your actual API keys:
   - `BRAINTRUST_API_KEY`: Your Braintrust API key
   - `OPENAI_API_KEY`: Your OpenAI API key

2. Run the evaluation script:
   ```bash
   uv run app_store_reviews/eval_app_store_reviews.py
   ```
