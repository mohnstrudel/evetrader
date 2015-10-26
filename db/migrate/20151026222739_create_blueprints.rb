class CreateBlueprints < ActiveRecord::Migration
  def change
    create_table :blueprints do |t|
      t.integer :type_id
      t.integer :product_id
      t.string :name
      t.integer :production_time

      t.timestamps null: false
    end
  end
end
