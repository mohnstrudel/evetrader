class CreateBlueprints < ActiveRecord::Migration
  def change
    create_table :blueprints do |t|
      t.integer :item_id
      t.integer :component_id

      t.timestamps null: false
    end
  end
end
