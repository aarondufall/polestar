defmodule Polestar.SmartRouter do
  require Logger

  def init(options) do
    options
  end

  def call(conn, _opts) do
    route(conn.method, conn.path_info, conn)
  end

  def route("GET", path_info, conn) do
    # basic route route
    Logger.info "Path info #{path_info}"
    conn |> Plug.Conn.send_resp(200, "Hello, world!")
  end

  def route(_, _, conn) do
    # catch all
    conn |> Plug.Conn.send_resp(404, "oops")
  end
end