require_relative 'getdata'
# Here we're receiving an array of orders, which are fully perfect for our need
# We just need to find the cheapest ingredients for our blueprint

module Calculation
	require 'nokogiri'

	def self.findBestPrice(options = {})
		# get the Material Effeciency level (range from 0 to 10 per cent)
		meLevel = options[:meLevel]
		
		# Establish containers for data
		@productionCost = []
		@recommendations = []

		print "Printing options: #{options}"

		options[:components].each do |component|
			@orderArray = []

			# In case we're looking for the final product we need to set the quantity to 1, because
			# in each 'portion' of a blueprint we're creating 1 product. For components we have
			# individual quantities, which are provided in the options. Furthermore, if there is a
			# given Material Effeciency level we need to reduce those amount by the given percentage.
			# Eve Online always rounds up (meaning 2.1 will be 3), thus, using ceil method
			if component['quantity']
				componentQuantity =  (component['quantity'].to_f * meLevel).ceil
			else
				componentQuantity = 1
			end
			
			@componentTypeID =   component['product_type_id']
	
			begin
				@order_array = Getdata.parseEveCentral(@componentTypeID, options[:mode])
			rescue Exception => e
				puts e.message
			end

			# puts "Printing writeRecommentations"
			# puts @orderArray
			# puts componentTypeID

			@order_array.each_with_index do |order, index|
				#within returned sell orders we now search for station name, price and volume remained

				stationName = order.search('station_name').text
				price = order.search('price').text
				volRemain = order.search('vol_remain').text

				#Just some nice formatted output to make sure everything works
				#puts "At station #{stationName} there are #{volRemain} #{parsedAnswer.search('itemname').text} for #{price} each."

				# ... save the prices into the array
				
				@orderArray << {typeid: @componentTypeID, stationName: stationName, price: price, volRemain: volRemain}
			end
			

			# Write some recommendations for buying/selling
			puts "Recommendations report for #{component['product_type_id']}: "
			Benchmark.bm do |x|
				x.report do 
					unless @orderArray.empty?
						@recommendations << writeRecommendations(@orderArray, componentQuantity * options[:minAmount], {mode: options[:mode]} ) 	
					else
						return "No data available"
					end
				end
			end

			puts "Production cost report for #{component['product_type_id']}: "
			Benchmark.bm do |x|
				x.report { @productionCost << returnCalculatedPrices(@orderArray, @componentTypeID, componentQuantity * options[:minAmount], options[:mode])*componentQuantity.to_i }
			end
		end
		# for each component we now find the middle min price given the amount of components needed (quantity amount) and multiply by required amount of that
		# component
		# debug
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
		Benchmark.bm do |x|
			x.report("Selecting for #{typeid} :") do 
				@unsortedPrices = ordersArray.select { |x| x[:typeid] == typeid }
			end
		end
		# sort by price to find always the cheapest
		
		Benchmark.bm do |x|
			x.report("Sorting for #{typeid} :") do
				case mode
				when :sell
					@sortedPrices = @unsortedPrices.sort_by {|a| a[:price].to_i}
					#p "mode is #{mode}"
				when :buy
					@sortedPrices = @unsortedPrices.sort_by {|a| a[:price].to_i*-1}
					#p "mode is #{mode}"
				end
			end
		end

		#p sortedPrices
		#calculate cheapest middle price
		puts "CalculatedMiddlePrice result for #{typeid}:"
		calculateMiddlePrice(@sortedPrices, amount)
	end

	def self.calculateMiddlePrice(prices, amount)
		volume_remaining = amount

  		total = prices.reduce(0) do |sum, item|
	    if item[:volRemain].to_i > volume_remaining
	      sum, volume_remaining = sum + item[:price].to_i * volume_remaining, 0
	      break sum
	    end
	    volume_remaining -= item[:volRemain].to_i
	    sum + item[:price].to_i * item[:volRemain].to_i
	  end

	  if volume_remaining > 0
	  	return total / (amount - volume_remaining)
	  else
	  	return total / amount
	  end
	  # return total / amount unless volume_remaining > 0
	  # raise "Required volume of #{amount} could not be satisfied!"
	end

	def self.calculateMiddlePriceWORKING(prices, amount)
		@runner = amount
		@price = 0
		i = 0
		Benchmark.bm do |x|
			x.report("New middle prices :") do
				# all the code goes in here
				
				while @runner > 0 do
					if prices[i]
						# Here we need to substract from each price item the volume to
						# figure out how many pieces we need yet to cover
						# puts @runner
						price_item = prices[i] 
						# Here we need to substract from each price item the volume to
						# figure out how many pieces we need yet to cover
						stationQuantity = price_item[:volRemain].to_i
						
						runner_to_check = @runner - stationQuantity
						stationPrice = price_item[:price].to_i
						if runner_to_check > 0
							@price += stationQuantity * stationPrice
						else
							@price += @runner * stationPrice
						end
						i += 1
						@runner -= stationQuantity

					else
						return @price
					end
				end
				return (@price/amount)
				
			end
		end
	end

	def self.calculateMiddlePriceOLD(prices, amount)
		Benchmark.bm do |x|
			x.report("Flatting the map :") do
				@order = prices.lazy.flat_map{|item| [item[:price].to_i] * item[:volRemain].to_i }.force #step 1      
			end
		end
		debug
		Benchmark.bm do |x|
			x.report("Conditional for Middle prices: ") do
			  unless amount > @order.count
			  	@order[1..amount].reduce(:+)/amount #step 2
			  else
			  	@order.reduce(:+)/@order.count
			  end
			end
		end
	end

	def self.writeRecommendations(array, amount, options = {})
		# p "first array: #{array}"

		array = sortArray(array, options[:mode])

		@sliceResult = returnIndexForSlice(array, amount)
		@recommendationsAmount = amount
		

		range = @sliceResult[0]
		lastValue = @sliceResult[1]

		@recommendationsArray = array.slice(0,range)

		case options[:mode]
		when :cheap
			verb = "buying"
		when :expensive
			verb = "selling"
		end

		# This conditional is covering 3 cases:
		# There is only one result in recom array (for example you need 300 units and
		# the very first offer gives you 401230 units, we only need to return 300)
		# The second conditional checks if the last value of recom array exceeds the
		# variable "last value" (which gives us the remaning amount required). If yes,
		# we need to return the last value to user. (for example we have an output 
		# 50 20 40, but only need 80 units. In this case we need to print out for the
		# _last_ item not 40, but 10)

		if @recommendationsArray[0][:volRemain].to_i > @recommendationsAmount
			@recommendationsArray[0][:volRemain] = @recommendationsAmount
			return @recommendationsArray
		elsif @recommendationsArray[-1][:volRemain].to_i > lastValue
			@recommendationsArray[-1][:volRemain] = lastValue
			return @recommendationsArray
		else
			return @recommendationsArray
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
