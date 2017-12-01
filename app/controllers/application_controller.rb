class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_home
  
  private

    def set_home
      @home = Home.first
      if @home.nil?
  	  	@home = Home.new
  	  	@home.name = "东莞市唯真金属材料压延有限公司"
  	  	@home.profile = "东莞市唯真金属压延有限公司，位于东莞市凤岗镇，紧邻凤深大道及清平高速，交通便利;属于深圳市唯真电机有限公司旗下的子公司，于2015年4月20日正式投入生产。"
  	  	@home.save
  	  end
  	end
    def after_sign_in_path_for(resource_or_scope)
       signed_in_root_path(resource_or_scope)
    end
end
