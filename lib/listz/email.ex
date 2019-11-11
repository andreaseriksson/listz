defmodule Listz.Email do
  import Swoosh.Email
  use Phoenix.Swoosh, view: ListzWeb.EmailView, layout: {ListzWeb.LayoutView, :email}

  @default_from "no-reply@example.com"

  def welcome_email(user) do
    new()
    |> to(user.email)
    |> from(@default_from)
    |> subject("Welcome to Listz")
    |> render_body(:welcome, %{user: user})
  end
end
