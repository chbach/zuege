module ApplicationHelpers

	def css(*stylesheets)
		stylesheets.map do |stylesheet|
			"<link href=\"/css/#{stylesheet}.css\" media=\"all\" rel=\"stylesheet\" />"
		end.join
	end

	def js(*scripts)
		scripts.map do |script|
			"<script src=\"/js/#{script}.js\" type=\"text/javascript\" /></script>"
		end.join
	end

end
