defmodule UserApiWeb.UserController do
  use UserApiWeb, :controller

  alias UserApi.Accounts
  alias UserApi.Accounts.User

  action_fallback(UserApiWeb.FallbackController)

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"name" => name, "email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.create_user(%{name: name, email: email, password: password}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end


  # def create(conn, %{"name" => name, "email" => email, "password" => password}) do
  #   changeset = User.changeset(%User{}, %{name: name, email: email, password: password})

  #   case Repo.insert(changeset) do
  #     {:ok, user} -> render(conn, user: user, status: 201)
  #     {:error, changeset} -> render(conn, changeset.errors, status: 422)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

#   def show(conn, %{"id" => id}) do
#     IO.puts(id)
#     user = User |> Accounts.get_user!(id)
# IO.puts(user)
#     case user do
#       nil ->
#         conn
#         |> put_status(:not_found)
#         |> json(%{error: "User not found"})
#       _ ->
#         conn
#         |> put_status(:ok)
#         |> json(%{
#           id: user.id,
#           name: user.name,
#           email: user.email
#         })
#     end
#   end

  def update(conn, %{"id" => id, "name" => name, "email" => email, "password" => password}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, %{name: name, email: email, password: password}) do
      render(conn, :show, user: user)
    end
  end

  # def update(conn, %{"id" => id, "name" => name, "email" => email, "password" => password}) do
  #   user = User |> Repo.get(id)

  #   case user do
  #     nil -> render(conn, status: 404, json: %{})
  #     _ ->
  #       changeset = User.changeset(user, %{name: name, email: email, password: password})

  #       case Repo.update(changeset) do
  #         {:ok, user} -> render(conn, user: user)
  #         {:error, changeset} -> render(conn, changeset.errors, status: 422)
  #       end
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

#  def delete(conn, %{"id" => id}) do
#     user = User |> Repo.get(id)

#     case user do
#       nil -> render(conn, status: 404, json: %{})
#       _ ->
#         case Repo.delete(user) do
#           {:ok, _} -> send_resp(conn, :no_content, "")
#           {:error, _} -> render(conn, "Could not delete user", status: 422)
#         end
#     end
#   end

end
