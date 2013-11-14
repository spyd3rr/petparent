require 'pp'

namespace :test do	
	desc "yelp scrape test"
	task :yelp => :environment do

		f = File.open(Rails.root + "app/_etc/numbers.csv")
		lines = f.read
		lines = lines.split(/\r/)
		puts "Total phone numbers: #{lines.count}"

		client = Yelp::Client.new
		
		no_results = Array.new
		successfully_added = Array.new
		empty_num = '5129784000'
		one_result = '5124523883'
		two_result = "5124771566"

		lines.each_with_index do |l, index|
			request = Yelp::V1::Phone::Request::Number.new(
		        :phone_number => l,
		        :yws_id => 'DddPUdF2dTlJuw9Q_FaDzQ')
			response = client.search(request)
			pp response["businesses"].length

			if response["businesses"].length == 0
				no_results.push(l)
			else
				new_venue = nil
			end
		end
	end
end