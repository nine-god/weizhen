class Message < ApplicationRecord
	validates :title, presence: { message: "<标题> 不能空白哦！" },length: { maximum: 20 ,message: "<标题> 写的太长了哦～"}
	validates :username, presence: { message: "<姓名> 不能空白哦！" }, length: { maximum: 20,message: "<姓名> 写的太长了哦～" }
	validates :tel, presence: { message: "<联系电话> 不能空白哦！" }, length: { maximum: 20 ,message: "<联系电话> 写的太长了哦～"}
	validates :email, length: { maximum: 20 ,message: "<电子邮箱> 写的太长了哦～"}
	validates :company, length: { maximum: 50 ,message: "<公司名称> 写的太长了哦～"}
	validates :address, length: { maximum: 100,message: "<地址> 写的太长了哦～" }
	validates :text, length: { maximum: 500 ,message: "<留言> 写的太长了哦～"}
end
