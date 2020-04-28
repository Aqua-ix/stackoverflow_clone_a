use Croma

defmodule StackoverflowCloneA.MapUtil do
  defun from_struct_recursively(%{__struct__: _} = s :: struct) :: map do
    from_struct_recursively_imp(s)
  end

  defp from_struct_recursively_imp(%{__struct__: _} = v) do
    Map.new(Map.from_struct(v), fn {key, value} -> {key, from_struct_recursively_imp(value)} end)
  end
  defp from_struct_recursively_imp(v) when is_list(v) do
    Enum.map(v, &from_struct_recursively_imp/1)
  end
  defp from_struct_recursively_imp(v) do
    v
  end

  defun stringify_keys(v :: v[map]) :: map do
    Poison.encode!(v) |> Poison.decode!()
  end

  defun underscore_keys(map :: v[map]) :: map do
    underscore_keys_imp(map)
  end

  defp underscore_keys_imp(map) when is_map(map) do
    Map.new(Enum.map(map, fn {k, v} -> {Macro.underscore(k), underscore_keys_imp(v)} end))
  end
  defp underscore_keys_imp(v) when is_list(v) do
    Enum.map(v, &underscore_keys_imp(&1))
  end
  defp underscore_keys_imp(v) do
    v
  end
end
