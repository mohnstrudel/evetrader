class FixColumnNameForBlueprints < ActiveRecord::Migration
  def change
  	rename_column :blueprints, :product_id, :product_type_id
  end
end
