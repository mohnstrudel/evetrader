class NewsController < ApplicationController
  before_action :find_news, only: :show

  def index
    url = "http://blog.handsomecake.com/"

    doc = Nokogiri::HTML(open(url))

    @nodes = doc.css('article.category-evetrader')
  	# @news = News.all.order(created_at: :desc)
  end

  def show

  end

  private

  def find_news
  	@news = News.find(params[:id])
  end
end
