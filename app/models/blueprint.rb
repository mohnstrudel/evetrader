class Blueprint < ActiveRecord::Base
	has_many :blueprint_items
	has_many :items, through: :blueprint_items

	scope :search, ->(search){ where(name: search) if search.present?}

end
