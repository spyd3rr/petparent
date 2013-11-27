class Venue < ParseResource::Base
  #has_many :events, :dependent => :destroy
  #has_many :tags

  fields :address, :address2, :city, :coordinate, :content, :favoriteUsers, :image, :name, :phone, :photos, :rating, :reportFlag, :state, :tags, :thumbnail, :tips, :zip, :nameStripped, :websiteUrl, :crop_x, :crop_y, :crop_w, :crop_h, :image1

  validates_presence_of :name
  before_update :copy_venue

  #include Paperclip::Glue



  #include Paperclip::Glue
  #has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  def copy_venue
    self.nameStripped = self.name.downcase.gsub(/[^0-9A-Za-z' ']/, '')
  end

  #include CarrierWave::Uploader
  #mount_uploader :thumbnail, ImageUploader

  def venue_tags
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

  def self.tags_to_ids(arg1="")
    names=arg1.split(',')
    ids = []
    names.each do |name|
      tag=Tag.find_by_name(name)
      ids << tag.id if tag
    end
    ids
  end


  def self.tags_to_pointer(tag_ids=[])
    tags_array = []
    tag_ids.each do |tag_id|
      tag_hash = Parse::Query.new("Tag").eq("objectId", tag_id).get.first
      tags_array << tag_hash.pointer if tag_hash
    end
    return tags_array
  end
  #Venue.tags_to_pointer(['c3kim0simY','7RN01J2QVP'])

  def self.all_venues
    venues = []
    v = Venue.all
    venues =  v.collect(&:name)
  end



  def self.search(search)
    if search
      #where('name LIKE ?', "%#{search}%")
      #where(:name => "{'$regex':'#{search}'}")
      #where={"$or":[{"wins":{"$gt":150}},{"wins":{"$lt":5}}]}
      where('$or'=>[{:nameStripped => {'$regex'=>"#{search}"}},{:city => {'$regex'=>"#{search}"}}])
      #where(:nameStripped => {'$regex'=>"#{search}"})
    #else
      #scoped
    end
  end



 end
