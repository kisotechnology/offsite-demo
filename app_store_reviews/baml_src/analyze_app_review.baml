// Function to analyze app store reviews
function AnalyzeAppReview(review: string) -> ReviewAnalysis {
  client "openai/gpt-4o"
  prompt #"
    {{_.role("user")}}
    You are an expert at analyzing app store reviews to extract structured insights. Your task is to analyze the following app review and extract key information in a structured format.

    App review: {{review}}

    Please analyze this review and extract the following information:
    1. The overall sentiment (positive, negative, or neutral)
    2. The intensity of the sentiment (low, medium, high, or null if not discernible)
    3. Any actions the user has taken or threatens to take
    4. Topics mentioned in the review along with specific subtopics

    Provide your analysis with precision - only include information that is explicitly stated or strongly implied.

    {{ctx.output_format}}
  "#
}

