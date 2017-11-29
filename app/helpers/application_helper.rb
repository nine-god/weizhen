module ApplicationHelper
	def generate_abstract_tag(html,length=200)
		text = strip_tags(html)
		text = text.delete("\n\r")[0..length] + "..."
		return text
	end
end
