class Venue < ParseResource::Base
  #has_many :events, :dependent => :destroy
  #has_many :tags

  fields :address, :address2, :city, :coordinate, :description, :favoriteUsers, :image, :name, :phone, :photos, :rating, :reportFlag, :state, :tags, :thumbnail, :tips, :zip
end
