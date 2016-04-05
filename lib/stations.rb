module Stations
	require 'open-uri'
	require 'nokogiri'
	require 'json'

	def self.findStations(solarSystems)
		# This method checks for given Solar Systems all Staitions within those systems
		# it is required, because the quicklook api from eve-central doesn't return
		# solar systems (only regions and stations). Thus we need to perform one single
		# query on required goods and then select only the - here returned - stations


		# If solarSystems are handed over to us via string and not numbers, we need to look up 
		# for them on Crest API and retrieve their ID
		solarSystems = solarSystems.map { |a| a.to_i }

		facilities = Array.new
		url = "https://public-crest.eveonline.com/industry/facilities/"
		
		doc = Nokogiri::HTML(open(url))
		data = JSON.parse(doc)
		# p data
		
		data['items'].each_with_index do |item, index|
			# p index
			if solarSystems.include?(item["solarSystem"]["id"] )
				facilities << item["facilityID"]
			end
		end

		return facilities
	end

end