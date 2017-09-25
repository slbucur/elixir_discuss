defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller


  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    token = Phoenix.Token.sign(conn, "user socket", user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        conn
        |> assign(:user, user)
        |> assign(:user_token, token)

      true ->
        assign(conn, :user, nil)
    end
  end
end