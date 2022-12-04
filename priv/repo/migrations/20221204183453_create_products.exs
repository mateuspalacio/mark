defmodule Mark.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :decimal
      add :img, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:products, [:category_id])
  end
end
