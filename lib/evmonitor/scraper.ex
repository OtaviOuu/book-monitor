defmodule Evmonitor.Scraper do

  def get_book_data(title) do
    url = "https://www.estantevirtual.com.br/busca?categoria=ciencias-exatas&q=#{title}&sort=new-releases"
    books =
      url
        |> get_html
        |> parse_html
        |> get_all_books
        |> Enum.map(&mount_book_map/1)
    books
  end
  defp get_html(url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    body
  end
  defp parse_html(body) do
    {:ok, document} = Floki.parse_document(body)
    document
  end
  defp get_all_books(doc) do
    Floki.find(doc, ".product-list__items #product-item")
  end
  defp mount_book_map(book_doc) do
    %{
      title: Floki.find(book_doc, "h2.product-item__title") |> List.first |> Floki.text() |> String.trim(),
      price: Floki.find(book_doc, ".product-item__text--darken") |> List.first |> Floki.text() |> String.trim(),
      img: Floki.find(book_doc, ".product-item__image") |> List.first() |> Floki.attribute("data-src")
    }
  end
end
