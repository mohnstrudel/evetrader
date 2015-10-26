class BlueprintItem < ActiveRecord::Base
	belongs_to :blueprint
	belongs_to :item
end
