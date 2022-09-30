defmodule Browser1Web.Router do
  import Browser1Web.Plugs.Redirect
  use Browser1Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Browser1Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/hangman", Browser1Web do
    pipe_through :browser

    get "/", HangmanController, :index
    post "/", HangmanController, :new
    put "/", HangmanController, :update
    get "/current", HangmanController, :show
  end

  redirect path: "/", to: "/hangman"


  # Other scopes may use custom stacks.
  # scope "/api", Browser1Web do
  #   pipe_through :api
  # end
end
