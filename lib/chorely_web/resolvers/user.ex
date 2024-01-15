defmodule ChorelyWeb.Resolvers.UserResolver do
  alias Chorely.Accounts

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def sign_in(_, %{email: email, password: password}, _) do
    case Chorely.Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        {:error, "Invalid email or password"}

      user ->
        token = Accounts.generate_user_session_token(user)
        {:ok, Map.put(user, :token, token)}
    end
  end

  def register(
        _,
        %{registration_input: input},
        _
      ) do
    case Chorely.Accounts.register_user(input) do
      {:ok, user} ->
        token = Accounts.generate_user_session_token(user)
        {:ok, Map.put(user, :token, token)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def logout(_, _, %{context: context}) do
    if context[:current_user] do
      {:ok, Chorely.Accounts.delete_user_session_tokens(context.current_user)}
    else
      {:ok, :ok}
    end
  end
end
