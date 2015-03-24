defmodule MAD.Mixfile do
  use Mix.Project

  def project do
    [app: :mad,
     version: "0.9.0",
     description: "Small and fast rebar replacement",
     package: package]
  end

  defp package do
    [files: ~w(c_src doc include priv src LICENSE package.exs README.md rebar.config),
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/synrc/mad"}]
   end
end
