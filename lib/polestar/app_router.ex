defmodule Polestar.AppRouter do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  forward "/", to: Polestar.SmartRouter

  match _ do
    send_resp(conn, 404, "oops")
  end
end