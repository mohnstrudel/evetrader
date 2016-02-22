class StaticPagesController < ApplicationController
  def home
  	@blueprint_amount = Blueprint.all.count
  end

  def about
  end
end
