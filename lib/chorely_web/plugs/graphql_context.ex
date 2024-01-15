defmodule ChorelyWeb.GraphqlContext do
  import Plug.Conn

  alias Chorely.Accounts
  alias Chorely.Accounts.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)

    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    put_user(%{}, conn)
  end

  defp put_user(context, conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         %User{} = current_user <- Accounts.get_user_by_session_token(token) do
      Map.put(context, :current_user, current_user)
    else
      _ -> context
    end
  end
end
