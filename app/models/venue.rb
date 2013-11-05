class Venue < ParseResource::Base
  #has_many :events, :dependent => :destroy
  #has_many :tags

  fields :address, :address2, :city, :coordinate, :description, :favoriteUsers, :image, :name, :phone, :photos, :rating, :reportFlag, :state, :tags, :thumbnail, :tips, :zip, :venue_name

  validates_presence_of :name
  before_save :copy_venue

  def copy_venue
    self.venue_name = self.name.downcase
  end

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

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

 end
