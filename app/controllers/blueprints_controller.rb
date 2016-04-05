class BlueprintsController < ApplicationController
	before_action :find_blueprint, only: [:show]
	include Calculation
	include Getdata

	def index
		@total_amount = Blueprint.all.count
		@blueprints = Blueprint.search(params[:search])
		@amount = @blueprints.count
	end

	def show

		if params[:solarSystems].nil?
			@solarSystems = 'custom'
		else
			@solarSystems = params[:solarSystems]
		end

		@meLevel = ((100 - params[:meLevel].to_f)/100)

		if  params[:minAmount].nil? or params[:minAmount].empty?
			@minAmount = 1
		else
			@minAmount = params[:minAmount].to_i
		end

		if params[:productPrices].nil?
			@product_mode = 'sell'
		else
			@product_mode = 'buy'
		end

		if params[:materialPrices].nil?
			@materials_mode = 'sell'
		else
			@materials_mode = 'buy'
		end

		@endproduct_multuplicator = @blueprint.product_type_quantity
		componentsHash = @blueprint.blueprint_items
		product = [@blueprint]
		
		myComponents = Calculation.findBestPrice({components: componentsHash, minAmount: @minAmount, mode: @materials_mode.to_sym, meLevel: @meLevel, solarSystems: @solarSystems})
		myProduct = Calculation.findBestPrice({components: product, minAmount: (@minAmount*@endproduct_multuplicator), mode: @product_mode.to_sym, meLevel: @meLevel, solarSystems: @solarSystems})
		
		unless myComponents.class == String or myProduct.class == String
			@productionPrice = myComponents[0]
			@buyRecommendations = myComponents[1]

			@sellPrice = myProduct[0][0]*@endproduct_multuplicator
			@sellRecommendations = myProduct[1]

			@profit = @sellPrice - @productionPrice.sum

			if @profit > 0
				@profit_class = "text-success"
				@word_result = "PROFIT"
				@arrow_class = "fa-arrow-up"
			else
				@word_result = "LOSS"
				@profit_class = "text-danger"
				@arrow_class = "fa-arrow-down"
			end
		else
			@error = myComponents
		end
	end

	private

	def find_blueprint
		@blueprint = Blueprint.find(params[:id])
	end
end
