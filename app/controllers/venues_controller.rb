require 'pp'

class VenuesController < ApplicationController
  # GET /venues
  # GET /venues.json
  helper_method :sort_column, :sort_direction

  def index
    #@venues = Venue.all

    if params[:search] && params[:search]!=''
      @venues = Venue.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    else
      @venues = Venue.order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    end
    #raise @venues.all.to_yaml

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new
    _tags = Tag.all
    @tag_names = _tags.collect(&:name)
    @photos = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    unless @venue
      @venue = Venue.create#(:name => 'venue name')
    end
    @tags = @venue.venue_tags
    _tags = Tag.all
    @tag_names = _tags.collect(&:name)
    @photos = get_photos(@venue.id)
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])
    @photos = []
    @venue.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:venue][:rating] = params[:venue][:rating].to_f
    params[:venue][:reportFlag] = params[:venue][:reportFlag].to_f

    if params[:tag_names]
      #venue = Parse::Query.new("Venue").eq("objectId", @venue.id).get.first
      ids=Venue.tags_to_ids(params[:tag_names])
      tags_array=Venue.tags_to_pointer(ids)
      params[:venue][:tags] = tags_array
      #venue.save
    end

    params[:venue][:nameStripped] = params[:venue][:name].downcase.gsub(/[^0-9A-Za-z' ']/, '') if params[:venue][:name]
    params[:venue][:image] = Photo.image_upload(params[:venue][:image]) if params[:venue][:image]
    #params[:venue][:thumbnail] = params[:venue][:image]

    respond_to do |format|
      if @venue.save
        if params[:photo] and params[:photo][:pictures_attributes]
          params[:photo][:pictures_attributes].each do |pic|
            photo_id = pic[1][:id]
            #raise photo_id.to_yaml
            Photo.set_photos("Venue", photo_id, @venue.id)
          end
        end
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])
    @photos = []
    @venue.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:venue][:rating] = params[:venue][:rating].to_f
    params[:venue][:reportFlag] = params[:venue][:reportFlag].to_f


    if params[:tag_names]
      #venue = Parse::Query.new("Venue").eq("objectId", @venue.id).get.first
      ids=Venue.tags_to_ids(params[:tag_names])
      tags_array=Venue.tags_to_pointer(ids)
      params[:venue][:tags] = tags_array
      #venue.save
    end

    params[:venue][:nameStripped] = params[:venue][:name].downcase.gsub(/[^0-9A-Za-z' ']/, '') if params[:venue][:name]
    params[:venue][:image] = Photo.image_upload(params[:venue][:image]) if params[:venue][:image]
    #params[:venue][:thumbnail] = params[:venue][:image]


    if params[:photo] and params[:photo][:pictures_attributes]
      params[:photo][:pictures_attributes].each do |pic|
        photo_id = pic[1][:id]
        Photo.set_photos("Venue", photo_id, @venue.id)
      end
    end

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end

  # GET /venues/find
  def find
    pp "Recieved Input:"
    pp params[:contains]
    if params[:contains]
      searchterm = params[:contains].gsub(/[^0-9a-z ]/i, '') #.upcase
      pp "Searching for #{searchterm}...."
      @venues = Parse::Query.new("Venue").regex("nameStripped", searchterm).get
      @venues = @venues.collect { |v| {:label => "#{v["name"]} (#{v["address"]})", :value => "#{v["name"]} (#{v["address"]})", :id => v.id} }
      pp @venues
    else
      pp "No input"
      @venues = []
    end

    render json: @venues
  end

  def get_photos(id)
    photos=Photo.get_photos("Venue", id)
  end

  def delete_venue_photo
    photo = Photo.find(params[:photo_id])
    photo.destroy
    render :json => {:status => 'ok'}
  end

  def upload_images
      image = Photo.image_upload(params[:painting])
      @painting = Photo.create_photos(image)
      #photo_id = @painting.id
      #raise photo_id.to_yaml
  end

  private

  def sort_column
    params[:sort] ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
