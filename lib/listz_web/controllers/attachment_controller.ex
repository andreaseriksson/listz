defmodule ListzWeb.AttachmentController do
  use ListzWeb, :controller

  alias Listz.Lists
  alias Listz.Attachment

  def delete(conn, %{"list_id" => list_id}) do
    list = Lists.get_list_by_slug!(list_id)

    :ok = Attachment.delete({list.attachment, list})
    {:ok, _} = Lists.update_list(list, %{attachment: nil})

    conn
    |> put_flash(:info, "Attachment deleted successfully.")
    |> redirect(to: Routes.list_path(conn, :show, list.slug))
  end
end
