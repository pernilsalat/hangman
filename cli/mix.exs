defmodule Cli.MixProject do
  use Mix.Project

  def project do
    [
      app: :cli,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      included_applications: [ :hangman ],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :hangman, path: "../hangman" }
    ]
  end
end
