class News < ActiveRecord::Base

	def to_param
		"#{id} #{title}".parameterize
	end

	def to_keywords
  		title.split(" ")
  	end
end
