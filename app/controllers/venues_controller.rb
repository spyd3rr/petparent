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
    #unless @venue
    #  @venue = Venue.create
    #end
    @tags = @venue.venue_tags
    _tags = Tag.all
    @tag_names = _tags.collect(&:name)
    @photos = get_photos(@venue.id)
  end

  def edit2
    @venue = Venue.find(params[:id])
    @photos = get_photos(@venue.id)
  end

  def edit2update
    #raise params.to_yaml
    if false and params[:crop_x]
      params[:crop_y]
      params[:crop_w]
      params[:crop_h]
      fun=Parse::Cloud::Function.new("cropVenueImage")
      image_params = {:id=> params[:id],:crop_x => params[:crop_x],:crop_y => params[:crop_y],:crop_w => params[:crop_w],:crop_h => params[:crop_h]}
      fun.call(image_params)
    end

    params[:venue][:crop_x] = params[:venue][:crop_x].to_f
    params[:venue][:crop_y] = params[:venue][:crop_y].to_f
    params[:venue][:crop_w] = params[:venue][:crop_w].to_f
    params[:venue][:crop_h] = params[:venue][:crop_h].to_f

    ee = Parse::Query.new(params[:image_object]).eq("objectId", params[:image_object_id]).get.first
    params[:venue][:image1] = ee["image"] unless ee["image"].nil?
    #params[:venue][:image] = Photo.image_upload(params[:venue][:image]) if params[:venue][:image]

    @venue = Venue.find(params[:id])
    if @venue.update_attributes(params[:venue])
      redirect_to @venue, notice: 'Venue was successfully updated.'
    else
      @photos = get_photos(@venue.id)
      render action: "edit2"
    end
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

    respond_to do |format|
      if @venue.save
        if params[:photo] and params[:photo][:pictures_attributes]
          params[:photo][:pictures_attributes].each do |pic|
            photo_id = pic[1][:id]
            #raise photo_id.to_yaml
            Photo.set_photos("Venue", photo_id, @venue.id)
          end
        end
        #format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        #format.json { render json: @venue, status: :created, location: @venue }
        format.html { redirect_to edit2_venue_path, :id => @venue.id  }
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


    if params[:photo] and params[:photo][:pictures_attributes]
      params[:photo][:pictures_attributes].each do |pic|
        photo_id = pic[1][:id]
        Photo.set_photos("Venue", photo_id, @venue.id)
      end
    end

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        #format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        #format.json { head :no_content }
        format.html { redirect_to edit2_venue_path, :id => @venue.id  }
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
