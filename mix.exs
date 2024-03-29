defmodule MAD.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mad,
      version: "7.11.0",
      description: "MAD Manage Dependencies",
      package: package(),
      deps: deps()
    ]
  end

  def application do
     []
  end

  def package do
    [
      files: ~w(include src priv mix.exs rebar.config),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :mad,
      links: %{"GitHub" => "https://github.com/synrc/mad"}
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.11", only: :dev},
      {:exe, "~> 4.1.1"}
    ]
  end
end
