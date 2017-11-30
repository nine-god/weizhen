class HomeController < ApplicationController
  before_action :authenticate_user!,only: [:update]
  def index
    @home = Home.first
    @articles = Article.all.order('created_at DESC').limit(3)
    @products = Product.all.order('created_at ASC').limit(3)
  end
  def show
  	 
  end
  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to @home, notice: 'home was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def home_params
      params.require(:home).permit(:name, :profile)
    end
end
