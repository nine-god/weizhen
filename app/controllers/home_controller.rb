class HomeController < ApplicationController
  before_action :authenticate_user!,only: [:update]
  def index

    # 让 UserMailer 在保存之后发送一封欢迎邮件
        # UserMailer.welcome_email().deliver_later

    # @home = Home.first
    @articles = Article.all.order('created_at DESC').limit(4)
    @products = Product.all.order('created_at ASC').limit(3)
    @product_images=[]
    @products.each_with_index do |product,index| 
        image = Image.where(id: product.image_id).order('updated_at desc').first
        if image.nil?
          @product_images[index] = "/default_product.jpg"
        else
          @product_images[index] = "ueditor_resources/show_image?filename=#{image.name}&class_type=products&class_type_id=#{product.id}"
        end
      end
    @article_images=[]
    @articles.each_with_index do |article,index| 
      image = Image.where(id: article.image_id).order('updated_at desc').first
      if image.nil?
        @article_images[index] = "/default_article.jpg"
      else
        @article_images[index] = "ueditor_resources/show_image?filename=#{image.name}&class_type=articles&class_type_id=#{article.id}"
      end
    end

  end

  def show
  	 
  end

  def contact_us
    # @home = Home.first
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
