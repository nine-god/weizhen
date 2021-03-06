class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index,:show]


  # GET /products
  # GET /products.json
  def index
    @limit = params[:limit]||6
    @offset = params[:offset]||0
    @total = Product.count
    @products = Product.order("created_at desc").offset(@offset).limit(@limit)
    @manage = params[:manage]
    @images=[]
    @products.each_with_index do |product,index| 
        image = Image.where(id: product.image_id).order('updated_at desc').first
        if image.nil?
          @images[index] = "/default_product.jpg"
        else
          @images[index] = "ueditor_resources/show_image?filename=#{image.name}&class_type=products&class_type_id=#{product.id}"
        end
      
    end

  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        mini_image_id = create_or_update_mini_miage(product_id: @product.id ,profile: params[:product][:profile])
        @product.reload
        @product.update(image_id: mini_image_id)

        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        mini_image_id = create_or_update_mini_miage(product_id: @product.id ,profile: params[:product][:profile])
        @product.reload
        @product.update(image_id: mini_image_id)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :profile)
    end

    def create_mini_image(tmp)
      mini_magick = MiniMagick::Image.open(tmp.path)
      mini_magick.path
      w,h = mini_magick[:width],mini_magick[:height] #=> [2048, 1536]

      if w/h.to_f  > 2.5
        shaved_off = ((w-h*2.5)/2).round #=> 256
        mini_magick.shave "#{shaved_off}x0" #此处表示宽度上左右各截取shaved_off个像素，高度上截取0像素
      else
        shaved_off = ((h-w/2.5)/2).round #=> 256
        mini_magick.shave "0x#{shaved_off}" #此处表示高度上上下各截取shaved_off个像素，宽度上截取0像素
      end
        mini_magick.resize "457x183"
      return mini_magick
    end

    def create_or_update_mini_miage(args={})
        product_id = args[:product_id]
        profile = args[:profile]


        index = profile.index("ueditor_resources/show_image?")
        
        if index
          rindex = profile[index..profile.size-1].index("\" alt=\"\"/>")
          # "ueditor_resources/show_image?filename=2017_11_30_16_04_28_product_pic4.jpg&class_type=products&class_type_id=15
          img_html = profile[(index+29)..(index+rindex-1)] 
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
      

          tmp = Tempfile.new("#{product_id}.jpg")  
          tmp.path # => /tmp/tmp20110928-12389-8yyc6w  
          tmp.syswrite(source_data)  
          tmp.close  
          mini_magick = create_mini_image(tmp)
          data = File.read(mini_magick.path)
          base64_data = Base64.encode64(data) 

          mini_image = Image.where(
            class_type: "products",
            class_type_id: product_id,
            product_id: product_id
            ).where("name like 'mini_%'").first
          unless  mini_image.nil?
            mini_image.destroy
          end
          mini_image = Image.create(
              class_type: "products",
              class_type_id: product_id,
              product_id: product_id,
              name: "mini_" + Time.now.strftime("%Y_%m_%d_%H_%M_%S_") + "#{product_id}.jpg"
            )
          mini_image.update(data:base64_data)

          mini_image_id = mini_image.id
          tmp.unlink # => 删除文件 
        end
        if index.nil?
          mini_image = Image.where(
            class_type: "products",
            class_type_id: product_id,
            product_id: product_id
            ).where("name like 'mini_%'").first
          mini_image.destroy if mini_image
          mini_image_id = nil 
        end
        return mini_image_id
    end
end
