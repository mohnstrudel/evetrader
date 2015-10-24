class Item < ActiveRecord::Base

	validates :name, :typeid, presence: true

	has_many :blueprints
	has_many :components, through: :items
end
