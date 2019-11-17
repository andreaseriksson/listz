defmodule ListzWeb.Plugs.PutUserToken do
  import Plug.Conn

  alias Listz.Users.User

  def init(options), do: options

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      %User{} = current_user ->
        token = Phoenix.Token.sign(conn, "user socket", current_user.id)

        assign(conn, :user_token, token)
      _ ->
        conn
    end
  end
end
