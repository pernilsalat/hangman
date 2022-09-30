defmodule BrowserLiveWeb.Live.Game.FigureSelector do
  use BrowserLiveWeb, :live_component
  alias BrowserLiveWeb.Live.Game.Figures

  def render(assigns) do
    ~H"""
    <div class="figure">
      <div class="choice-figure">
        <input type="radio" name="figure" value="ascii" checked={assigns.figure == "ascii"} phx-click="change_figure" phx-value-figure="ascii">
        <label for="figure">ascii</label>
        <input type="radio" name="figure" value="svg" checked={assigns.figure == "svg"} phx-click="change_figure" phx-value-figure="svg">
        <label for="figure">svg</label>
      </div>
      <%= if assigns.figure == "svg" do %>
        <%= live_component(Figures.SvgFigure, tally: assigns.tally, id: 10) %>
      <%= else %>
        <%= live_component(Figures.AsciiFigure, tally: assigns.tally, id: 11) %>
      <%= end %>
    </div>
    """
  end
end
