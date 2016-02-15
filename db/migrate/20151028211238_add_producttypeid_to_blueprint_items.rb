class AddProducttypeidToBlueprintItems < ActiveRecord::Migration
  def change
    add_column :blueprint_items, :product_type_id, :integer
  end
end
