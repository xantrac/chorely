defmodule ChorelyWeb.Schema do
  use Absinthe.Schema

  alias Crudry.Middlewares.TranslateErrors

  import_types(ChorelyWeb.Schema.UserTypes)

  def middleware(middleware, field, %Absinthe.Type.Object{identifier: identifier})
      when identifier in [:query, :subscription, :mutation] do
    if Absinthe.Type.meta(field, :no_auth) do
      middleware
    else
      [ChorelyWeb.Middlewares.Authentication | middleware] ++ [TranslateErrors]
    end
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  # The query and mutation blocks is where you can add custom absinthe code
  query do
    field :me, :user do
      resolve(&ChorelyWeb.Resolvers.UserResolver.me/3)
    end
  end

  mutation do
    field :sign_in, :user_with_token do
      meta(:no_auth, true)

      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&ChorelyWeb.Resolvers.UserResolver.sign_in/3)
    end

    field :register, :user_with_token do
      meta(:no_auth, true)

      arg(:registration_input, non_null(:registration_input))
      resolve(&ChorelyWeb.Resolvers.UserResolver.register/3)
    end

    field :logout, :string do
      meta(:no_auth, true)

      resolve(&ChorelyWeb.Resolvers.UserResolver.logout/3)
    end
  end
end
