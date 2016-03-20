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

	def twitter_share
		"There is a nifty resource for EVE productioneers, check it out: http://eve-trader.com @EveOnline @MohnstrudelLove"
	end

	def facebook_share
		return "http://eve-trader.net", "http://eve-trader.com - new resource for EVE Online productioneers"
	end
end
