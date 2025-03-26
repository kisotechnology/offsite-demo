from typing import Any, Awaitable, Callable, Dict, TypeVar

from autoevals import JSONDiff
from baml_client import b
from baml_client.types import (
    ReviewAnalysis,
)
from baml_py import Collector
from braintrust import (
    Eval,
    EvalHooks,
    Score,
    SpanTypeAttribute,
    init_dataset,
    start_span,
    traced,
)
from dotenv import load_dotenv

PROJECT_NAME = "App Store Reviews"


# Type variable for the return type of the BAML function
T = TypeVar("T")


async def with_llm_logging(
    baml_func: Callable[..., Awaitable[T]],
    baml_args: Dict[str, Any],
) -> T:
    """
    Helper function to call a BAML function with LLM logging.

    Args:
        baml_func: The BAML function to call
        baml_args: Arguments to pass to the BAML function
        registry: The client registry to use

    Returns:
        The result of the BAML function call
    """
    with start_span(name="BAML LLM Call", type=SpanTypeAttribute.LLM) as span:
        # Create a collector to capture token usage and raw request/response
        collector = Collector()

        # Add the registry to the baml_options
        baml_args["baml_options"] = {
            "collector": collector,
        }

        # Call the BAML function
        result = await baml_func(**baml_args)

        # Log the request, response, and token usage
        last_log = collector.last
        if last_log:
            llm_request = (
                last_log.selected_call.http_request.body
                if last_log.selected_call and last_log.selected_call.http_request
                else None
            )
            llm_response = last_log.raw_llm_response
            input_tokens = collector.usage.input_tokens or 0
            output_tokens = collector.usage.output_tokens or 0
            metrics = {
                "prompt_tokens": input_tokens,
                "completion_tokens": output_tokens,
                "total_tokens": input_tokens + output_tokens,
            }
            span.log(input=llm_request, output=llm_response, metrics=metrics)

        return result


@traced
async def analyze_review(review_text: str, _hooks: EvalHooks) -> ReviewAnalysis:
    """Task function for Braintrust evaluation that analyzes a review and evaluates the results"""
    return await with_llm_logging(
        b.AnalyzeAppReview,
        {"review": review_text},
    )  # type: ignore


async def json_diff_summary(
    input: str, output: ReviewAnalysis, expected: dict
) -> Score:
    diff = JSONDiff()
    return await diff.eval_async(output.model_dump(), expected)


def main():
    load_dotenv()

    dataset = init_dataset(name="synthetic_ground_truth", project=PROJECT_NAME)

    return Eval(
        PROJECT_NAME,
        data=dataset,
        task=analyze_review,
        scores=[json_diff_summary],
    )


if __name__ == "__main__":
    main()
