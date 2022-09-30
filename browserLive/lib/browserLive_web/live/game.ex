defmodule BrowserLiveWeb.Live.Game do
  use BrowserLiveWeb, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = socket |> assign(%{ game: game, tally: tally, figure: "svg" })
    { :ok, socket }
  end
  
  def handle_event("make_move", %{ "key" => key }, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)
    { :noreply, assign(socket, :tally, tally ) }
  end

  def handle_event("change_figure", %{ "figure" => figure }, socket) do
    { :noreply, assign(socket, :figure, figure ) }
  end

  def render(assigns) do
    ~H"""
    <div class="game-holder" phx-window-keyup="make_move">
      <%= live_component(__MODULE__.FigureSelector, tally: assigns.tally, figure: assigns.figure, id: 1) %>
      <%= live_component(__MODULE__.Alphabet, tally: assigns.tally, id: 2) %>
      <%= live_component(__MODULE__.WordsSoFar, tally: assigns.tally, id: 3) %>
    </div>
    """
  end
end