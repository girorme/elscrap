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

    if opts[:extract_links] do
      links = request(url)
      |> extract_links

      if opts[:save], do: save_links(links)
    end
  end

  defp request(url) do
    IO.puts("Extracting urls from: #{url}\n")
    {:ok, response} = Tesla.get(url)
    response.body
  end

  defp extract_links(response_body) do
    {:ok, document} = Floki.parse_document(response_body)

    links = document
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.filter(fn href -> String.trim(href) != "" end)
    |> Enum.filter(fn href -> String.starts_with?(href, "http") end)
    |> Enum.uniq

    links
  end

  defp save_links(links) do
    IO.puts("Saving links:")
    IO.inspect(links)
  end
end
