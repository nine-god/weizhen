class Article < ApplicationRecord
	has_many :images , dependent: :destroy
	validates :title, presence: { message: "<产品名称> 不能空白哦！" },length: { maximum: 32 ,message: "<产品名称> 写的太长了，不能超过32个字哦!"}

end
