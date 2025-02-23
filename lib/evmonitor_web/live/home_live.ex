defmodule EvmonitorWeb.HomeLive do
  use Phoenix.LiveView
  alias Evmonitor.Scraper

  def mount(_params, _session, socket) do
    {:ok, assign(socket, books_titles: [])}
  end


  def render(assigns) do
    ~H"""
    <div class="bg-gray-100">
      <div class="container mx-auto py-8">
        <div class="mb-4">
          <form phx-submit="get-data">
            <div class="mb-4">
              <input
                type="text"
                name="book_name"
                class="border p-2 rounded"
                placeholder="Digite o nome do livro"
                required
              />
            </div>
          </form>
        </div>
        <div class="text-center">
          <h1 class="text-4xl font-bold">Books</h1>
          <div class="grid grid-cols-3 gap-6 mt-8">
            <div :for={book <- @books_titles} class="bg-white rounded-lg shadow-lg p-4 flex flex-col items-center">
              <img class="w-48 h-64 object-cover rounded-md mb-4" src={book.img} alt="Book Cover" />
              <p class="text-center text-lg font-semibold text-gray-800">{book.title}</p>
              <p class="text-center text-lg font-semibold text-gray-800">{book.price}</p>

            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("get-data", %{"book_name" => title}, socket) do
    {:noreply, assign(socket, books_titles: Scraper.get_book_data(title))}
  end
end
