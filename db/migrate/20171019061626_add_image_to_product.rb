class AddImageToProduct < ActiveRecord::Migration[5.1]
  def create
    add_column :products, :image, :string
  end
end
