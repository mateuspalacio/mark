defmodule MarkWeb.CategoryController do
  use MarkWeb, :controller

  alias Mark.Categories
  alias Mark.Categories.Category
  alias Mark.Repo
  alias Mark.Products.Product
  alias Mark.Accounts

  plug :check_auth when action in [:new, :create, :edit, :update, :delete]

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
    current_user = Accounts.get_user!(user_id)

    conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: Routes.category_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    categories = Categories.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Categories.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
      case Categories.create_category(category_params) do
        {:ok, category} ->
          conn
          |> put_flash(:info, "Category created successfully.")
          |> redirect(to: Routes.category_path(conn, :show, category))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
  end

  def show(conn, %{"id" => id}) do
    category =
      id
      |> Categories.get_category!
      |> Repo.preload([:products])
    changeset = Product.changeset(%Product{}, %{})
    render(conn, "show.html", category: category, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    changeset = Categories.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(id)

    case Categories.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    {:ok, _category} = Categories.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end

  def add_product(conn, %{"product" => product_params, "category_id" => category_id}) do
    category =
      category_id
      |> Categories.get_category!()
      |> Repo.preload([:products])
    case Categories.add_product(category_id, product_params) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "product added :)")
        |> redirect(to: Routes.category_path(conn, :show, category))
      {:error, _error} ->
        conn
        |> put_flash(:error, "product not added :(")
        |> redirect(to: Routes.category_path(conn, :show, category))
    end
  end
end
