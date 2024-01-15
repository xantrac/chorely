defmodule ChorelyWeb.Middlewares.Authentication do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: _}} = resolution, _config) do
    resolution
  end

  def call(resolution, _config) do
    Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
  end
end
