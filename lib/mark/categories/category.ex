defmodule Mark.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Mark.Products.Product

  schema "categories" do
    field :name, :string
    has_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
