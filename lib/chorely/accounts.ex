defmodule Chorely.Accounts do
  use Ash.Api,
    extensions: [
      AshGraphql.Api
    ]

  graphql do
    # Defaults to `true`, use this to disable authorization for the entire API (you probably only want this while prototyping)
    authorize?(false)
  end

  resources do
    resource(Chorely.Accounts.User)
    resource(Chorely.Accounts.Token)
  end
end
