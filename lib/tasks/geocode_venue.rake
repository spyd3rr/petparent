namespace :geo_find do
  desc "yelp scrape test"
  task :ll => :environment do
    venues=Venue.all
    count = 0
    venues.each do |v|
      address = v.address ? v.address : ''
      address2 = v.address2 ? v.address : ''
      city = v.city ? v.city : ''
      state = v.state ? v.state : ''
      location = address + ' ' + address2 + ' ' + city + ' ' + state
      puts v.id
      puts location
      s=Geocoder.search(location)
      next if s.empty?
      puts s[0].latitude,s[0].longitude
      v.coordinate = ParseGeoPoint.new :latitude => s[0].latitude.to_f, :longitude => s[0].longitude.to_f
      v.save
      count += 1
      #break
    end
    puts count
  end
end


