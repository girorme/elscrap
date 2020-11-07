defmodule Escrap.Cli do
  def main (args \\ []) do
    args
    |> parse_args
    |> scrap
  end

  defp parse_args(args) do
    {opts, _value, _} =
    args
    |> OptionParser.parse(switches: [extract_links: :boolean])

    opts
  end

  defp scrap(opts) do
    url = opts[:url] || nil

    unless url do
      IO.puts("Url required")
      System.halt(0)
    end

    if opts[:extract_links], do: extract_links(url)
  end

  defp extract_links(url) do
    IO.puts("Extracting urls from: #{url}\n\n")
  end
end
