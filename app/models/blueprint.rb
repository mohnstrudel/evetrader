class Blueprint < ActiveRecord::Base
	has_many :blueprint_items
	has_many :items, through: :blueprint_items

	scope :search, ->(search){ where('keywords LIKE ?', "%#{search.downcase}%") if search.present?}

	before_save :set_keywords

	protected
		def set_keywords
			self.keywords = [name, typeid].map(&:downcase).join(' ')
		end
end
