defmodule Listz.Presence do
  use Phoenix.Presence, otp_app: :listz, pubsub_server: Listz.PubSub
end
