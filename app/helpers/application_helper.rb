module ApplicationHelper

	#function to return the full title of page 
	def full_title(page_title_in)
		# base_title = "Ruby on Rails Tutorial Sample App"
		base_title = "Sample App"
		if page_title_in.empty?
			return base_title
		else
			return "#{base_title} | #{page_title_in}"
		end
	end

end
