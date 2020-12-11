defmodule OpenapiToGraphql.CLI do
  def main(args \\ []) do
    args
    |> Enum.flat_map(&Path.wildcard/1)
    |> Enum.each(fn path ->
      Parser.block(path) |> IO.puts()
    end)
  end
end
