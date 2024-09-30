defmodule PhoenixDemo.LegalPages do
  alias PhoenixDemo.Repo

  alias PhoenixDemo.Schemas.LegalPages

  def get_page(name) do
    Repo.get_by(LegalPages, name: name)
  end
end
