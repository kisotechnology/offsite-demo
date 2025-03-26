// Learn more about clients at https://docs.boundaryml.com/docs/snippets/clients/overview

// Example client for GPT-4o. Can also be invoked as `client: "openai/gpt-4o"`
client<llm> GPT4o {
  provider openai
  options {
    model gpt-4o
  }
}
