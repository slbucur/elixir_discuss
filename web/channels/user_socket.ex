defmodule Discuss.UserSocket do
  @max_age 2 * 7 * 24 * 60 * 60

  use Phoenix.Socket
  alias Discuss.User
  alias Discuss.Repo

  ## Channels
  channel "comments:*", Discuss.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        user = Repo.get!(User, user_id)
        {:ok, assign(socket, :user, user)}
      {:error, _reason} ->
        :error
    end
  end

  def id(_socket), do: nil
end
