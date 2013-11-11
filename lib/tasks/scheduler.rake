require 'pp'

namespace :test do	
	desc "yelp scrape test"
	task :yelp => :environment do
		client = Yelp::Client.new
		
		no_results = Array.new
		successfully_added = Array.new
		empty_num = '5129784000'
		one_result = '5124523883'
		two_result = "5124771566"

		request = Yelp::V1::Phone::Request::Number.new(
            :phone_number => empty_num,
            :yws_id => 'DddPUdF2dTlJuw9Q_FaDzQ')
		response = client.search(request)
		pp response["businesses"].length

		if response["businesses"].length == 0
			no_results.push(current_number)
		else
			pp response["businesses"]
		end
	end
end