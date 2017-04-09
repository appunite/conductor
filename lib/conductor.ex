defmodule Conductor do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :conductor_marks, accumulate: true)
      @before_compile Conductor
      @on_definition Conductor
    end
  end

  def __on_definition__(env, _kind, name, _args, _guards, _body) do
    authorize = Module.get_attribute(env.module, :authorize)

    if authorize do
      mark = %Conductor.Mark{action: name, scope: authorize[:scope]}

      Module.put_attribute(env.module, :conductor_marks, mark)
      Module.delete_attribute(env.module, :authorize)
    end
  end

  defmacro __before_compile__(env) do
    marks = Module.get_attribute(env.module, :conductor_marks)

    plugs =
      Enum.reduce(marks, [handle_not_marked(marks)], fn(mark, acc) ->
        [handle_mark(mark) | acc]
      end)

    quote do
      unquote(plugs)
    end
  end

  defp handle_mark(%Conductor.Mark{action: action, scope: scope}) do
    quote do
      plug Conductor.Plugs.Authorize, unquote(scope) when var!(action) in [unquote(action)]
    end
  end

  defp handle_not_marked(marks) do
    marked_actions = Enum.map(marks, &Map.get(&1, :action))

    quote do
      plug Conductor.Plugs.Authorize, nil when not var!(action) in unquote(marked_actions)
    end
  end
end
