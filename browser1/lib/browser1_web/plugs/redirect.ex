defmodule Browser1Web.Plugs.Redirect do
  alias Phoenix.Controller

  @spec init(Keyword.t) :: Keyword.t
  def init([to: _] = opts), do: opts
  def init(_default), do: raise("Missing required to: option in redirect")

  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn = %{ method: "GET" }, opts) do
    conn
    |> Controller.redirect(opts)
    |> Plug.Conn.halt()
  end
  def call(conn, _opts), do: conn

  defmacro redirect(redirect_opts, opts \\ [])
  defmacro redirect([path: path, to: to] = _redirect_opts, opts) do
    quote do
      match(:*, unquote(path), unquote(__MODULE__), [to: unquote(to)], opts: unquote(opts))
    end
  end
end