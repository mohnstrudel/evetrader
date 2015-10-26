class AddBlueprintsToBlueprintItems < ActiveRecord::Migration
  def change
    add_reference :blueprint_items, :blueprint, index: true, foreign_key: true
    add_reference :blueprint_items, :item, index: true, foreign_key: true
  end
end
