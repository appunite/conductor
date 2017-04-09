defmodule Conductor.Error do
  @moduledoc false

  defexception [:status, :response, :message]

  def new(status, response) do
    %__MODULE__{
      status: status,
      response: response,
      message: "Access Forbidden, code: #{status}"
    }
  end
end
