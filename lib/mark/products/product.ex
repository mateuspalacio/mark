defmodule Mark.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Mark.Categories.Category

  schema "products" do
    field :img, :string
    field :name, :string
    field :price, :decimal
    belongs_to(:category, Category)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :img, :category_id])
    |> validate_required([:name, :price, :img, :category_id])
  end
end
