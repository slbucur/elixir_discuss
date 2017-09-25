defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Topic, Comment}

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)

    topic = Repo.get(Topic, topic_id)

    IO.inspect(topic)

    {:ok, %{}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user = socket.assigns.user

    changeset = build_assoc(topic, :comments)
    changeset = build_assoc(user, :comments, changeset)
    changeset = Comment.changeset(changeset, %{content: content})


    case Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end