require_relative 'getdata'
# Here we're receiving an array of orders, which are fully perfect for our need
# We just need to find the cheapest ingredients for our blueprint

module Calculation
	require 'nokogiri'

	def self.findBestPrice(options = {})

		@productionCost = []
		@recommendations = []

		print "Printing options: #{options}"

		options[:components].each do |component|
			@orderArray = []

			# In case we're looking for the final product we need to set the quantity to 1, because
			# in each 'portion' of a blueprint we're creating 1 product. For components we have
			# individual quantities, which are provided in the options
			if component['quantity']
				componentQuantity =  component['quantity']
			else
				componentQuantity = 1
			end
			
			componentTypeID =   component['product_type_id']
	
			@order_array = Getdata.parseEveCentral(componentTypeID, options[:mode])

			puts "Printing writeRecommentations"
			puts @orderArray
			puts componentTypeID

			@order_array.each_with_index do |order, index|
				#within returned sell orders we now search for station name, price and volume remained

				stationName = order.search('station_name').text
				price = order.search('price').text
				volRemain = order.search('vol_remain').text

				#Just some nice formatted output to make sure everything works
				#puts "At station #{stationName} there are #{volRemain} #{parsedAnswer.search('itemname').text} for #{price} each."

				# ... save the prices into the array
				
				@orderArray << {typeid: componentTypeID, stationName: stationName, price: price, volRemain: volRemain}
			end
			

			# Write some recommendations for buying/selling
			puts 'Recommendations report: '
			Benchmark.bm do |x|
				x.report { @recommendations << writeRecommendations(@orderArray, componentQuantity.to_i * options[:minAmount], {mode: options[:mode]} ) }
			end

			puts 'Production cost report: '
			Benchmark.bm do |x|
				x.report { @productionCost << returnCalculatedPrices(@orderArray, componentTypeID, componentQuantity.to_i * options[:minAmount], options[:mode])*componentQuantity.to_i }
			end
		end
		# for each component we now find the middle min price given the amount of components needed (quantity amount) and multiply by required amount of that
		# component
		return @productionCost, @recommendations
	end

	def self.sortArray(array, mode)
		# Sort array depending on the mode. If expensive, then the most valuable should be on top,
		# if cheap, then most cheapest should be on top
		case mode
		when :sell
			sortedPrices = array.sort_by {|a| a[:price].to_i}
			#p "mode is #{mode}"
		when :buy
			sortedPrices = array.sort_by {|a| a[:price].to_i*-1}
			#p "mode is #{mode}"
		end

		return sortedPrices
	end

	def self.returnCalculatedPrices(ordersArray, typeid, amount, mode)
	# here we need two Arrays to store prices and remained volumes from a sorted Array (because we need the cheapest!)
		@volumeArray = Array.new
		
		# here we select from the huge array only specific (required) typeid's
		unsortedPrices = ordersArray.select {|x| x[:typeid] == typeid}

		# sort by price to find always the cheapest
		case mode
		when :sell
			sortedPrices = unsortedPrices.sort_by {|a| a[:price].to_i}
			#p "mode is #{mode}"
		when :buy
			sortedPrices = unsortedPrices.sort_by {|a| a[:price].to_i*-1}
			#p "mode is #{mode}"
		end

		#p sortedPrices
		#calculate cheapest middle price
		calculateMiddlePrice(sortedPrices, amount)
	end


	def self.calculateMiddlePrice(prices, amount)
		order = prices.flat_map{|item| [item[:price].to_i] * item[:volRemain].to_i } #step 1      
	  unless amount > order.count
	  	order[1..amount].reduce(:+)/amount #step 2
	  else
	  	order.reduce(:+)/order.count
	  end
	end

	def self.writeRecommendations(array, amount, options = {})
		# p "first array: #{array}"



		array = sortArray(array, options[:mode])



		sliceResult = returnIndexForSlice(array, amount)

		range = sliceResult[0]
		lastValue = sliceResult[1]

		newArray = array.slice(0,range)

		case options[:mode]
		when :cheap
			verb = "buying"
		when :expensive
			verb = "selling"
		end
		newArray.each do |arrayValue|
			unless arrayValue.equal? newArray.last
				return newArray
				# p "We recommend #{verb} #{arrayValue[:volRemain]} of #{arrayValue[:typeid]} at #{arrayValue[:stationName]}"
			else
				# return newArray
				return newArray, lastValue
				# p "We recommend #{verb} #{lastValue} of #{arrayValue[:typeid]} at #{arrayValue[:stationName]}"
			end
		end
	end


	def self.returnIndexForSlice(array, amount)
		# p "print some array: #{array}"
		@array = array
		@test = array

		# lets return some proper sorted array
		@array.each_index do |index|
			#sum += array[index][:volume]
			# p "amount:"
			amount -= @array[index][:volRemain].to_i
			
			if amount <= 0
				# p "this if kicks in"
				return index+1, @array[index][:volRemain].to_i+amount
			end	
			@result = index
			
		end

		return @result+1, @array[@result][:volRemain].to_i
	end

end
