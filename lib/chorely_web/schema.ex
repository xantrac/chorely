defmodule ChorelyWeb.Schema do
  use Absinthe.Schema

  @apis [Chorely.Accounts]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
  end
end
