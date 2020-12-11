defmodule Parser do
  def block(path) do
    {:ok, content} = YamlElixir.read_from_file(path)

    case content["type"] do
      "object" ->
        """
        # imported from: #{path}
        #{content["type"]} #{object_type(content)} do
        #{
          Enum.map(content["properties"], &field(&1, content["required"] || [], path))
          |> Enum.join("\n")
        }
        end
        """

      _ ->
        """
        # fail to import: #{path}
        """
    end
  rescue
    e in MatchError ->
      """
      # fail to import: #{e.term |> elem(1) |> Map.get(:message)} in #{path}
      """
  end

  def object_type(content), do: ":#{content["title"] |> Macro.underscore()}"

  def field({name, spec}, required, path) do
    "  field(:#{name}, #{type(spec, name not in required, path)}#{
      description(spec["description"])
    })"
  end

  def type(%{"type" => "array", "items" => %{"$ref" => ref}}, _, path) do
    {:ok, content} = YamlElixir.read_from_file("#{Path.dirname(path)}/#{ref}")

    "non_null(list_of(non_null(#{object_type(content)})))"
  end

  def type(%{"type" => "array", "items" => items}, _, path) do
    "non_null(list_of(non_null(:inline_object)))"
  end

  def type(spec, false, path), do: "non_null(#{type(spec, true, path)})"

  def type(%{"$ref" => ref}, true, path) do
    {:ok, content} = YamlElixir.read_from_file("#{Path.dirname(path)}/#{ref}")

    "#{object_type(content)}"
  end

  def type(spec, true, _), do: ":#{spec["format"] || spec["type"]}"

  def description(nil), do: ""
  def description(str), do: ", description: #{inspect(str)}"
end
