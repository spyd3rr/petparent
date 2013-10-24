class Event < ParseResource::Base
  #belongs_to :venue

  belongs_to :user

  #has_many :tags

  fields :address, :address2, :city, :coordinate, :description, :endDate, :image, :name, :price, :reportFlag, :startDate, :state, :tags, :thumbnail, :user, :venue, :zip
end
