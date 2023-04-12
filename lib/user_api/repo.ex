defmodule UserApi.Repo do
  use Ecto.Repo,
    otp_app: :user_api,
    adapter: Ecto.Adapters.Postgres
end
