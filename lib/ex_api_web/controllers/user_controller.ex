defmodule ExApiWeb.UserController do
  use ExApiWeb, :controller

  alias ExApiWeb.{User, Bookmark, Email}

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => params}) do
    user_params =
      case !Map.has_key?(params, "password") || params["password"] == "" do
        true ->  params |> generate_password(20)
        false -> params
      end
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("create.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ExApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def send(conn, %{"user_id" => user_id, "bookmark_id" => bookmark_id}) do
    try do
      user = Repo.get!(User, user_id)
      bookmark = Repo.get!(Bookmark, bookmark_id)
      spawn(fn() ->
        Task.Supervisor.start_child(EmailSupervisor, fn() ->
            IO.puts "U novom threadu sam"
            Email.compose_email(user, bookmark) 
            |> ExApi.Mailer.deliver_later
        end)
      end)
      IO.puts "Nastavio sam dalje"
      conn
      |> send_resp(:ok, "")
      rescue
        Ecto.NoResultsError ->
          conn
          |> send_resp(:not_found, "")
    end
  end

  defp generate_password(params, length) do
    pass = :crypto.strong_rand_bytes(length) 
           |> Base.encode64 
           |> binary_part(0, length)
    Map.put(params, "password", pass)
  end
end
