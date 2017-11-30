class Product < ApplicationRecord
	has_many :images , dependent: :destroy
	validates :name, presence: { message: "<产品名称> 不能空白哦！" },length: { maximum: 12 ,message: "<产品名称> 写的太长了，不能超过12个字哦!"}

end
