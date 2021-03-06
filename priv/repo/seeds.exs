# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Listz.Repo.insert!(%Listz.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Listz.{Lists, Repo}

Lists.list_lists
|> Enum.each(&Lists.delete_list/1)

Ecto.Adapters.SQL.query!(Repo, "DELETE FROM users WHERE inserted_at < (NOW() - INTERVAL '1 day')", [])
