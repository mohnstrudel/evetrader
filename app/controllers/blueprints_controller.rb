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
		if params[:minAmount].empty?
			@minAmount = 1
		else
			@minAmount = params[:minAmount].to_i
		end


		componentsHash = @blueprint.blueprint_items
		product = [@blueprint]
		
		myComponents = Calculation.findBestPrice({components: componentsHash, minAmount: @minAmount, mode: :sell})
		myProduct = Calculation.findBestPrice({components: product, minAmount: @minAmount, mode: :buy})
		unless myComponents.class == String or myProduct.class == String
			@productionPrice = myComponents[0]
			@buyRecommendations = myComponents[1]

			@sellPrice = myProduct[0][0]
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
