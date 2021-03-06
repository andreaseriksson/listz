defmodule ListzWeb.ListChannel do
  use ListzWeb, :channel

  def join("list:" <> _slug, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
