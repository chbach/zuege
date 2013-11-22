require 'mechanize'
require 'json'

class ScheduleParser

	def initialize(url = "http://www.westfalenbahn.de/fahrplaninfo.php")
		@url = url
	end

	def parse!
		time = DateTime.now
		puts time
		agent = Mechanize.new
		agent.user_agent_alias = 'Mac Safari'

		page = agent.get @url
		agent.page.encoding = "utf-8"

		search_form = page.form_with name: "frmKontakt"
		search_form.field_with(name: "hstelle").value = "92" # Horn-Bad Meinberg
		search_form.field_with(name: "date_day").value = time.day
		search_form.field_with(name: "date_month").value = time.month
		search_form.field_with(name: "date_year").value = time.year
		search_form.field_with(name: "time_hour").value = time.hour
		search_form.field_with(name: "time_minute").value = time.min

		search_results = agent.submit search_form
		@page_contents = search_results.parser

		read_schedule
	end

	def read_schedule
		table = @page_contents.css('.contentBox table.cnt')

		@schedule = table.search('tr').drop(1).map do |tr|
			td = tr.search 'td'

			{
				num: td[0].text.strip,
				arrival: td[1].text.strip,
				departure: td[2].text.strip,
				from: td[3].text.strip,
				to: td[4].text.strip,
				delay: td[5].text.gsub(/\u00a0/, ' ').strip
			}
		end
	end
end
