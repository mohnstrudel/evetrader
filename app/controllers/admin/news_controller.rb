class Admin::NewsController < AdminController

	before_action :find_news, only: [:edit, :update]

	def index
		@news = News.all
	end

	def new
		@news = News.new
	end

	def edit

	end

	def update
		@news.update(news_params)
		redirect_to admin_news_index_path
	end

	def create
		@news = News.new(news_params)
		@news.save
		redirect_to admin_news_index_path
	end


	private

	def find_news
		@news = News.find(params[:id])
	end

	def news_params
		params.require(:news).permit(:title, :body)
	end
end
