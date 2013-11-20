namespace :batch_operation do
  desc "update_coordinates of all"
  task :update_coordinates => :environment do
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
    puts " #{count} coordinates updated"
  end

  desc "update all thumbnails"
  task :update_thumbnails => :environment do
    events = Photo.page(1).per(1000).all
    count = 0
    events.each do |e|
      begin
        ee = Parse::Query.new("Photo").eq("objectId", e.id).get.first
        next if ee["image"].nil?
        e.image=ee["image"]
        e.save
        count += 1
      rescue Exception => exc
        puts exc.message
      end
    end
    puts " #{count} thumbnails updated"
  end

end


