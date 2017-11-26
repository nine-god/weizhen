module ApplicationHelper
	def generate_abstract_tag(html)
		text = strip_tags(html)
		text = text.delete("\n\r")[0..200] + "..."
		return text
	end
end
