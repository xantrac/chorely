defmodule ChorelyWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
  end

  object :user_with_token do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :token, :string
  end

  input_object :registration_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end
end
