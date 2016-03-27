defmodule Polestar do
  use Application
  require Logger
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the http endpoint when the application starts
      worker(Polestar.Endpoint, []),
      # Start router event register
      worker(Polestar.EventRegistry, [])
      # Start the Ecto repository
      # Here you could define other workers and supervisors as children
      # worker(Polestar.Worker, [arg1, arg2, arg3]),
    ]
    Logger.info "Staring Server"
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Polestar.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
