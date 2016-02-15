class Item < ActiveRecord::Base
	has_many :blueprint_items
	has_many :blueprints, through: :blueprint_items
end
