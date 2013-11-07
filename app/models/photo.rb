class Photo < ParseResource::Base

  fields :image, :reportFlag, :thumbnail, :user


  def self.get_photos(model_name,id)
    photos = Parse::Query.new("Photo").tap do |q|
      q.related_to("photos", Parse::Pointer.new({
                                                    "className" => model_name,
                                                    "objectId" => id
                                                }))
    end.get
    photos
  end

  def self.set_photos(model_name,photo_id,venue_id)
    venue = Parse::Query.new(model_name).eq("objectId", venue_id).get.first
    photo = Parse::Query.new("Photo").eq("objectId", photo_id).get.first
    venue.array_add_relation("photos", photo.pointer)
    venue.save
  end

  def self.image_upload(pic)
    #raise params[:venue][:image].read.to_yaml
    photo = Parse::File.new({
                                :body => pic.read,#IO.read("test/parsers.jpg"),
                                :local_filename => pic.original_filename,#"parsers.jpg",
                                :content_type => pic.content_type#"image/jpeg"
                            })
    photo.save
    return photo
  end


end
