class Blueprint < ActiveRecord::Base
	has_many :items, :through => :blueprint_items
end
