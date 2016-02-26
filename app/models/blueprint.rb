class Blueprint < ActiveRecord::Base
	has_many :blueprint_items
	has_many :items, through: :blueprint_items

	# scope :search, ->(search){ where('keywords LIKE ?', "%#{search.downcase}%") if search.present? else }

	before_save :set_keywords

	def self.search(keyword)
		if keyword.present?
			where('keywords LIKE ?', "%#{keyword.downcase}%")
		else
			limit(5).order("RANDOM()")
			# find(:all, :order => "type_id desc", :limit => 5).reverse
		end
	end

	protected
		def set_keywords
			self.keywords = [name, typeid].map(&:downcase).join(' ')
		end
end
