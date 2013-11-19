class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  helper_method :sort_column, :sort_direction

  def index
    if params[:search] && params[:search]!=''
      @events = Event.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    else
      @events = Event.order(sort_column + " " + sort_direction).page(params[:page]).per(30)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    #@venue_names = Venue.all_venues

    _tags = Tag.all
    @tag_names = _tags.collect(&:name)
    @photos = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    unless @event
      @event = Event.create#(:name => 'event name')
    end
    @tags = @event.event_tags
    _tags = Tag.all
    @tag_names = _tags.collect(&:name)
    @photos = get_photos(@event.id)
  end

  # POST /events
  # POST /events.json
  def create
    @photos = []
    @event = Event.new(params[:event])
    @event.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:event][:price] = params[:event][:price].to_f
    params[:event][:reportFlag] = params[:event][:reportFlag].to_f
    params[:event][:endDate] = params[:event][:endDate].to_datetime
    params[:event][:startDate] = params[:event][:startDate].to_datetime

    #if venue presents
    if params[:venue_id]
      venue = Parse::Query.new("Venue").eq("objectId", params[:venue_id]).get.first
      params[:event][:venue]=venue.pointer if venue
    end

    #if Users presents
    if session[:user_id]
      user = Parse::Query.new("User").eq("objectId", session[:user_id]).get.first
      params[:event][:user]=user.pointer if user
    end

    if params[:tag_names]
      #venue = Parse::Query.new("Venue").eq("objectId", @venue.id).get.first
      ids=Venue.tags_to_ids(params[:tag_names])
      tags_array=Venue.tags_to_pointer(ids)
      params[:event][:tags] = tags_array
      #venue.save
    end

    params[:event][:nameStripped] = params[:event][:name].downcase.gsub(/[^0-9A-Za-z' ']/, '') if params[:event][:name]
    params[:event][:image] = Photo.image_upload(params[:event][:image]) if params[:event][:image]
    #params[:event][:thumbnail] = params[:event][:image]


    respond_to do |format|
      if @event.save
        if params[:photo] and params[:photo][:pictures_attributes]
          params[:photo][:pictures_attributes].each do |pic|
            photo_id = pic[1][:id]
            Photo.set_photos("Event", photo_id, @event.id)
          end
        end
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    @photos = []
    @event.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:event][:price] = params[:event][:price].to_f
    params[:event][:reportFlag] = params[:event][:reportFlag].to_f
    params[:event][:endDate] = params[:event][:endDate].to_datetime
    params[:event][:startDate] = params[:event][:startDate].to_datetime

    #if venue presents
    if params[:venue_id]
      venue = Parse::Query.new("Venue").eq("objectId", params[:venue_id]).get.first
      params[:event][:venue]=venue.pointer if venue
    end

    #if Users presents
    if session[:user_id]
      #raise session[:user_id]
      user = Parse::Query.new("User").eq("objectId", session[:user_id]).get.first
      params[:event][:user]=user.pointer if user
    end

    if params[:tag_names]
      #venue = Parse::Query.new("Venue").eq("objectId", @venue.id).get.first
      ids=Venue.tags_to_ids(params[:tag_names])
      tags_array=Venue.tags_to_pointer(ids)
      params[:event][:tags] = tags_array
      #venue.save
    end

    params[:event][:nameStripped] = params[:event][:name].downcase.gsub(/[^0-9A-Za-z' ']/, '') if params[:event][:name]
    params[:event][:image] = Photo.image_upload(params[:event][:image]) if params[:event][:image]
    #params[:event][:thumbnail] = params[:event][:image]

    #if params[:painting]
    #  image = Photo.image_upload(params[:painting])
    #  @painting = Photo.create_photos(image)
    #  photo_id = @painting.id
    #  Photo.set_photos("Event", photo_id, @event.id)
    #else

    if params[:photo] and params[:photo][:pictures_attributes]
      params[:photo][:pictures_attributes].each do |pic|
        photo_id = pic[1][:id]
        Photo.set_photos("Event", photo_id, @event.id)
      end
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def get_photos(id)
    photos=Photo.get_photos("Event", id)
  end

  def delete_event_photo
    photo = Photo.find(params[:photo_id])
    photo.destroy
    render :json => {:status => 'ok'}
  end

  def upload_images
    image = Photo.image_upload(params[:painting])
    @painting = Photo.create_photos(image)
  end

  private

  def sort_column
    params[:sort] ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end


end
