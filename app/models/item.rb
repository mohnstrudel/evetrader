class Item < ActiveRecord::Base
	has_many :blueprints, through: :blueprint_items
end
