class UserMailer < ApplicationMailer
	  default from: 'nine-god@qq.com'

  def welcome_email()
  	@user = 'cym'
    @url  = 'http://www.wzyayan.com'
    @id_code = "#{rand(9)}#{rand(9)}#{rand(9)}#{rand(9)}"
    @to_mail = 'nine-god@qq.com'
    mail(to: @to_mail, subject: '东莞市唯真金属材料压延有限公司 帐号找回密码')
  end
end
