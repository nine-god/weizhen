module ApplicationHelper
	def generate_abstract_tag(html,length=200)
		text = strip_tags(html)
		text = text.delete("\n\r")[0..length] + "..."
		return text
	end
	def generate_pagination(args={})
		limit = args[:limit].to_i
		offset = args[:offset].to_i
		total = args[:total].to_i

		url = request.path
		first_page = 1
		last_page = (total%limit == 0) ? total/limit : total/limit+1
		current_page = offset/limit+1
		arr = []
		arr << "<li>每页#{limit}条,共#{total}条,第<input type='text' id='page_num' style='min-width: 30px;width:50px;' value='#{current_page}'>页<button type='button' onclick='goto_url(\"#{url}\",\"#{limit}\")'>Go</button>,共#{last_page}页</li>"
		arr << "<li><a href='#{url}?offset=#{(first_page-1)*limit}&&limit=#{limit}'>首页</a></li>"
		if current_page - first_page == 0
			arr << "<li class='disabled' ><a href='#{url}?offset=#{(current_page-1)*limit}&&limit=#{limit}'>上一页</a></li>"
		else
			arr << "<li><a href='#{url}?offset=#{(current_page-2)*limit}&&limit=#{limit}'>上一页</a></li>"
		end

		if last_page - current_page == 0
			arr << "<li class='disabled'><a href='#{url}?offset=#{(current_page-1)*limit}&&limit=#{limit}'>下一页</a></li>"
		else
			arr << "<li><a href='#{url}?offset=#{(current_page)*limit}&&limit=#{limit}'>下一页</a></li>"
		end		    
		arr << "<li><a href='#{url}?offset=#{(last_page-1)*limit}&&limit=#{limit}'>尾页</a></li>"
		return raw arr.join("")
	end
end
