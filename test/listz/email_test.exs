defmodule Listz.EmailTest do
  use ExUnit.Case

  alias Listz.Email
  alias Listz.Users.User

  test "welcome email" do
    user = %User{email: "john_doe@example.ex"}

    email = Email.welcome_email(user)

    assert email.to == [{"", user.email}]
    assert email.from == {"", "no-reply@example.com"}
    assert email.html_body =~ "Welcome"
    assert email.text_body =~ "Welcome"
  end
end
