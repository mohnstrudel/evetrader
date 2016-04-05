require_relative 'stations'
# We need stations module to find stations which belong to Solar Systems from (optional) user input

module Getdata
	require 'open-uri'
	require 'nokogiri'
	require 'benchmark'

	def self.readFileData
		stations = File.read("#{Rails.root}/app/assets/static/stations.txt")
		# stations = File.read('stations.txt')
		stations_array = stations[1..-2].split(',').collect! {|n| n.to_i}
		return stations_array

	end

	def self.parseEveCentral(typeid, options = {})
		# puts "Incoming typeID:"
		# print typeid
		solarSystems = options[:solarSystems]

		if solarSystems == "custom"
			@stations = readFileData
		else
			@stations = Stations.findStations(solarSystems)
		end

		mode = options[:mode]
		case mode
		when :buy
			order_verb = "buy_orders"
		when :sell
			order_verb = "sell_orders"
		end


		@result = Array.new

		# We're calling the quicklook with 5 regions - The Forge (Jita), Domain (Amarr), Sinq Laison (Dodixie), Heimatar (Rens), Metropolis (Hek)
		url = "http://api.eve-central.com/api/quicklook?typeid=#{typeid}&regionlimit=10000002&regionlimit=10000043&regionlimit=10000032&regionlimit=10000030&regionlimit=10000042"
		# url = "http://api.eve-central.com/api/quicklook?typeid=25601&usesystem=30000142"
		# url = "http://eve-marketdata.com/api/item_orders2.json?char_name=DiegoDelTorros&buysell=b&type_ids=25601&solarsystem_ids=30000142"
		# url = "http://api.eve-central.com/api/marketstat?typeid=25601&typeid=35&regionlimit=10000002"
		# url = "http://api.eve-central.com/api/quicklook?typeid=25601"
		Benchmark.bm do |x|
			x.report("Accessing eve-central API") do
				@doc = Nokogiri::HTML(open(url))
			end
		end
		
		Benchmark.bm do |x|
			x.report("Storing: ") do
				@doc.xpath("//#{order_verb}//order").each_with_index do |order, index|
				# puts order.at_xpath('station').inner_text
					if @stations.include?(order.at_xpath('station').inner_text.to_i)
					# We now store the desired orders (which are at the desired stations, which we
					# already calculated) in an array. I considered building a new XML @document with only
					# orders, which are desired, however saving in an array seems to be sufficient as well
						@result << order
					end
				end
			end
		end

		# puts "Printing result from EVE-central parsing for typeid: #{typeid}"
		
		# puts @result

		return @result
	end
end


# puts Calculation.parseEveCentral(25601)



# Now we need to find the output matching the solarSystems in our array


# Calculation.readFileData