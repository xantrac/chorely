defmodule Chorely.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshGraphql.Resource]

  attributes do
    uuid_primary_key(:id)
    attribute(:first_name, :string, allow_nil?: false)
    attribute(:last_name, :string, allow_nil?: false)
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    api(Chorely.Accounts)

    strategies do
      password :password do
        identity_field :email
        confirmation_required?(false)
        register_action_accept([:first_name, :last_name])
        sign_in_tokens_enabled? true
      end
    end

    tokens do
      enabled?(true)
      token_resource(Chorely.Accounts.Token)

      signing_secret Chorely.Accounts.Secrets
    end
  end

  actions do
    read :by_id do
      # This action has one argument :id of type :uuid
      argument(:id, :uuid, allow_nil?: false)
      # Tells us we expect this action to return a single result
      get?(true)
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter(expr(id == ^arg(:id)))
    end
  end

  graphql do
    type(:user)

    queries do
      get(:get_by_id, :by_id)

      read_one :sign_in_with_password, :sign_in_with_password do
        as_mutation?(true)
        type_name(:user_with_metadata)
      end
    end

    mutations do
      create :register_with_password, :register_with_password
    end
  end

  postgres do
    table("users")
    repo(Chorely.Repo)
  end

  identities do
    identity(:unique_email, [:email])
  end

  # If using policies, add the folowing bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
