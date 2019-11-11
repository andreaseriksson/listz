defmodule ListzWeb.ControllerCallbacks do
  use Pow.Extension.Phoenix.ControllerCallbacks.Base

  def before_respond(Pow.Phoenix.RegistrationController, :create, {:ok, user, conn}, _config) do
    Listz.Email.welcome_email(user)
    |> Listz.Mailer.deliver()

    {:ok, user, conn}
  end
end
