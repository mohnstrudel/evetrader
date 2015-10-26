class CreateBlueprintItems < ActiveRecord::Migration
  def change
    create_table :blueprint_items do |t|
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
