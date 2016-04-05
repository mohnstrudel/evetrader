class CreateSolarSystems < ActiveRecord::Migration
  def change
    create_table :solar_systems do |t|
      t.integer :system_id
      t.string :name

      t.timestamps null: false
    end
  end
end
