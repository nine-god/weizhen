class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index,:show]
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
    @manage = params[:manage]
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        mini_image_id = create_or_update_mini_miage(article_id: @article.id ,text: params[:article][:text])
        @article.reload
        @article.update(image_id: mini_image_id)
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        mini_image_id = create_or_update_mini_miage(article_id: @article.id ,text: params[:article][:text])
        @article.reload
        @article.update(image_id: mini_image_id)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :text)
    end

    def create_mini_image(tmp)
      mini_magick = MiniMagick::Image.open(tmp.path)
      mini_magick.path
      w,h = mini_magick[:width],mini_magick[:height] #=> [2048, 1536]

      if w/h.to_f  > 1.3
        shaved_off = ((w-h*1.3)/2).round #=> 256
        mini_magick.shave "#{shaved_off}x0" #此处表示宽度上左右各截取shaved_off个像素，高度上截取0像素
      else
        shaved_off = ((h-w/1.3)/2).round #=> 256
        mini_magick.shave "0x#{shaved_off}" #此处表示高度上上下各截取shaved_off个像素，宽度上截取0像素
      end
        mini_magick.resize "180x180"
      return mini_magick
    end

    def create_or_update_mini_miage(args={})
        article_id = args[:article_id]
        text = args[:text]


        index = text.index("ueditor_resources/show_image?")
        
        if index
          rindex = text[index..text.size-1].index("\" alt=\"\"/>")
          # "ueditor_resources/show_image?filename=2017_11_30_16_04_28_product_pic4.jpg&class_type=articles&class_type_id=15
          img_html = text[(index+29)..(index+rindex-1)] 
          arr = img_html.split("&")
          filename = arr[0].split("=")[1]
          class_type = arr[1].split("=")[1]
          class_type_id = arr[2].split("=")[1]

          image = Image.where(
            class_type: class_type,
            class_type_id:class_type_id,
            name: filename
            ).first
          source_data = Base64.decode64(image.data)
      

          tmp = Tempfile.new("#{article_id}.jpg")  
          tmp.path # => /tmp/tmp20110928-12389-8yyc6w  
          tmp.syswrite(source_data)  
          tmp.close  
          mini_magick = create_mini_image(tmp)
          data = File.read(mini_magick.path)
          base64_data = Base64.encode64(data) 

          mini_image = Image.where(
            class_type: "articles",
            class_type_id: article_id,
            article_id: article_id
            ).where("name like 'mini_%'").first
          unless  mini_image.nil?
            mini_image.destroy
          end
          mini_image = Image.create(
              class_type: "articles",
              class_type_id: article_id,
              article_id: article_id,
              name: "mini_" + Time.now.strftime("%Y_%m_%d_%H_%M_%S_") + "#{article_id}.jpg"
            )
          mini_image.update(data:base64_data)

          mini_image_id = mini_image.id
          tmp.unlink # => 删除文件 
        end
        if index.nil?
          mini_image = Image.where(
            class_type: "articles",
            class_type_id: article_id,
            article_id: article_id
            ).where("name like 'mini_%'").first
          mini_image.destroy if mini_image
          mini_image_id = nil 
        end
        return mini_image_id
    end
end
