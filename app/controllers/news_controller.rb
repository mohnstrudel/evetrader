class NewsController < ApplicationController
  before_action :find_news, only: :show

  def index
  	@news = News.all.order(created_at: :desc)
  end

  def show

  end

  private

  def find_news
  	@news = News.find(params[:id])
  end
end
