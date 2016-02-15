class BlueprintsController < ApplicationController
	before_action :find_blueprint, only: [:show]
	include Calculation

	def index
		@blueprints = Blueprint.all
	end

	def show
		productsHash = @blueprint.blueprint_items
		product = [@blueprint]
		file = File.read("#{Rails.root}/app/assets/static/newoutput.json")
		data = JSON.parse(file)
		@myComponents = Calculation.findBestPrice(data, {components: productsHash, minAmount: 100, mode: :cheap})
		@myProduct = Calculation.findBestPrice(data, {components: product, minAmount: 100, mode: :expensive})
	end

	private

	def find_blueprint
		@blueprint = Blueprint.find(params[:id])
	end
end
