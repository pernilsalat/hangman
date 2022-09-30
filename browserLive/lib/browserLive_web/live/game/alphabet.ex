defmodule BrowserLiveWeb.Live.Game.Alphabet do
  use BrowserLiveWeb, :live_component

  def mount(socket) do
    letters = (?a..?z) |> Enum.map(&<< &1 ::utf8 >>)
    { :ok, assign(socket, :letters, letters) }
  end
  
  defp class_of(letter, tally) do
    cond do
      Enum.member?(tally.letters, letter) -> "correct"
      Enum.member?(tally.used, letter) -> "wrong"
      true -> ""
    end
  end

  def render(assigns) do
    ~H"""
    <div class="alphabet">
      <%= for letter <- assigns.letters do %>
        <div
          class={"one-letter clickable #{class_of(letter, @tally)}"}
          phx-click="make_move"
          phx-value-key={letter}
        >
          <%= letter %>
        </div>
      <%= end %>
    </div>
    """
  end
end