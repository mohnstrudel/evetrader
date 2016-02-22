class AddKeywordsToBlueprints < ActiveRecord::Migration
  def change
    add_column :blueprints, :keywords, :text
  end
end
