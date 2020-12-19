defmodule Elscrap.Cli do
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

    unless url do # validação url
      IO.puts("Url required")
      System.halt(0)
    end

    if opts[:extract_links] do
      links = request(url)
      |> extract_links

      IO.puts("#{Enum.join(links, "\n")}")

      if opts[:save], do: save_links(url, links)
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

  defp save_links(url_id, links) do
    IO.puts("Saving links")

    file = "output/links.txt"

    content = links
    |> Enum.join("\n")

    case File.write(file, content) do
      :ok -> IO.puts("[#{url_id}] Links saved to: #{file}")
      {:error, reason} -> IO.puts("Error on save links: #{reason}")
    end
  end
end
