class AddBlueprintidToItems < ActiveRecord::Migration
  def change
    add_column :items, :blueprintid, :integer
  end
end
