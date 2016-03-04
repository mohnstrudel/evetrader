class AddProductQuantityToBlueprints < ActiveRecord::Migration
  def change
    add_column :blueprints, :product_type_quantity, :integer
  end
end
