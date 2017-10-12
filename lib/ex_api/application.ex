defmodule ExApi.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(ExApi.Repo, []),
      supervisor(ExApiWeb.Endpoint, []),
      supervisor(Task.Supervisor, [[name: EmailSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: ExApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
