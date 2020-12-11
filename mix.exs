defmodule OpenapiToGraphql.MixProject do
  use Mix.Project

  def project do
    [
      app: :openapi_to_graphql,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  defp escript do
    [main_module: OpenapiToGraphql.CLI]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 2.5"}
    ]
  end
end
