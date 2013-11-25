class Event < ParseResource::Base

  fields :address, :address2, :city, :coordinate, :description, :endDate, :image, :name, :price, :reportFlag, :startDate, :state, :tags, :thumbnail, :user, :venue, :zip, :websiteUrl, :ticketingUrl, :nameStripped, :crop_x, :crop_y, :crop_w, :crop_h, :image1

  validates_presence_of :name

  def event_tags
    hash_tags= self.tags
    tag_names = []
    unless hash_tags.nil? or hash_tags.empty?
      hash_tags.each_with_index do |hash_tag,i|
        #raise hash_tag.to_yaml
        tag = Tag.find hash_tag["objectId"]
        tag_names << tag.name if tag
      end
    end
    tag_names.join(",")
  end

  def self.search(search)
    if search
      where('$or'=>[{:nameStripped => {'$regex'=>"#{search}"}},{:city => {'$regex'=>"#{search}"}}])
    end
  end

end
