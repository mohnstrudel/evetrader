class Blueprint < ActiveRecord::Base
	has_many :blueprint_items
	has_many :items, through: :blueprint_items
end
