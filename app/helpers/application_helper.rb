module ApplicationHelper

	def formatBigNumber(number)
		number.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
	end

	def findPicture(typeid)
		url = "https://image.eveonline.com/Type/#{typeid}_32.png"
	end

	def findItemName(id)
		begin
			return Item.find(id).name
		rescue Exception => e
			return "Name not known to humanity yet."
		end
	end
end
