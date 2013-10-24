class Venue < ParseResource::Base
  #has_many :events, :dependent => :destroy
  #has_many :tags

  fields :address, :address2, :city, :coordinate, :description, :favoriteUsers, :image, :name, :phone, :photos, :rating, :reportFlag, :state, :tags, :thumbnail, :tips, :zip

  validates_presence_of :name

  #mount_uploader :thumbnail, ImageUploader

  def venue_tags
    hash_tags= self.tags
    tag_names = []
    unless hash_tags.nil? or hash_tags.empty?
      hash_tags.each_with_index do |hash_tag,i|
        #raise hash_tag.to_yaml
        tag = Tag.find hash_tag["objectId"]
        tag_names << tag.name
      end
    end
    tag_names
  end

 end
