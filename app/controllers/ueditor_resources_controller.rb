require 'base64'
class UeditorResourcesController < ApplicationController
  before_action :authenticate_user!,except: [:show]
  protect_from_forgery :only => [:handle_file] 
  def handle_file
    #ueditor是通过在url中的传入ueditor_action（原本为action，但是由于其与rails冲突，所以我将其改为了ueditor_action）字段来区分具体的操作的
    return if params[:ueditor_action].blank?
    cur_action = params[:ueditor_action]

    #刚进入页面时editor会进行config的访问
    if (cur_action == "config")
      #打开config.json文件，将其返回，注意，我这里是将config.json文件放在/public/plugins/ueditor/目录下，可以自己的需求，可以对这里进行相应的更改
      json = File.read("#{Rails.root}/public/plugins/ueditor/config.json")
      #返回结果
      render json: json 
    #图片上传
    elsif (cur_action == "uploadimage")
      upload_image
    else
      respond_result
    end
  end
  def show_image
    filename = params[:filename]
    class_type = params[:class_type]
    class_type_id = params[:class_type_id]
    file_dir = "#{Rails.root}/public/images_tempfile/#{class_type}/#{class_type_id}"
    file_path = file_dir + filename
    if File::exist?( file_path)
      source_data = File.read(file_path)
    else
      image = Image.where(
        class_type: class_type,
        class_type_id:class_type_id,
        name: filename
        ).first
      source_data = Base64.decode64(image.data)

      create_dir(file_dir)

      image_file = File.new(file_path, "w")
      image_file.syswrite(source_data)
      image_file.close

    end
    send_data( source_data, :filename => filename )
  end

private

  
  #上传图片的处理
  def upload_image
    tempfile = params[:upfile].tempfile
    filename = params[:upfile].original_filename
    split_url = params[:location_url].split("/")


    class_type = split_url[1]
    class_type_id = split_url[2]

    filename = Time.now.strftime("%Y_%m_%d_%H_%M_%S_") + filename
    data = File.read(tempfile.path)

    base64_data = Base64.encode64(data) 
    image = Image.new
    image.class_type = class_type
    image.data = base64_data 
    image.name = filename
    if class_type == "products"
      if class_type_id == "new"
         if Product.last.nil?
           class_type_id = 0
          else 
            class_type_id = Product.last.id
         end
      end
      image.product_id = class_type_id
    end
    if class_type == "articles"
      if class_type_id == "new"
         if Article.last.nil?
           class_type_id = 0
          else 
            class_type_id = Article.last.id
         end
      end
      image.article_id = class_type_id
    end
    image.class_type_id = class_type_id
    image.save

    respond_result(
      class_type: class_type,
      class_type_id:class_type_id,
      filename: filename,
      tempfile:tempfile
      )
  end

  #负责向客户端返回数据
  def respond_result(args={})
    filename = args[:filename]
    class_type = args[:class_type]
    class_type_id = args[:class_type_id]
    tempfile = args[:tempfile]
    response_json = {state: 'SUCCESS'}

    #构造需要返回的数据，这个是ueditor已经约定好的，不能随意对字段进行修改。
    unless filename.blank?
      response_json[:name]= filename 
      response_json[:originalName]= filename 
      response_json[:size]= File.size(tempfile) 
      response_json[:type]= File.extname(filename) 
      response_json[:url]= "http://#{request.host_with_port}/ueditor_resources/show_image?filename=#{filename}&class_type=#{class_type}&class_type_id=#{class_type_id}" 
  end

    render json: response_json
  end
  def create_dir(path)
      root = []
      arr = path.split("/").each{|each_path| 
        each_path
        root << each_path
        rs_path = root.join("/")
        unless Dir.exist?(rs_path)
          next if rs_path == ""
          Dir::mkdir(rs_path)
        end
      }

  end
end
