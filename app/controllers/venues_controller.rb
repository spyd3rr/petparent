class VenuesController < ApplicationController
  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all

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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    @tags = @venue.venue_tags
    _tags = Venue.all
    @tag_names = _tags.collect(&:name)
  end

  # POST /venues
  # POST /venues.json
  def create

    @venue = Venue.new(params[:venue])
    @venue.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:venue][:rating] = params[:venue][:rating].to_f
    params[:venue][:reportFlag] = params[:venue][:reportFlag].to_f

    #result = Venue.upload(uploaded_file.tempfile, uploaded_file.original_filename, content_type: uploaded_file.content_type)
    #@post.thumbnail = {"name" => result["name"], "__type" => "File"}
    #@venue.coordinate = ParseGeoPoint.new :latitude => params[:venue][:lat], :longitude => params[:venue][:long]

    respond_to do |format|
      if @venue.save
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
    #raise params[:image].to_yaml
    @venue = Venue.find(params[:id])
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

    params[:venue][:image] = Venue.image_upload(params[:venue][:image]) if params[:venue][:image]
    params[:venue][:thumbnail] = Venue.image_upload(params[:venue][:thumbnail]) if params[:venue][:thumbnail]

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
    if params[:contains]
      searchterm = params[:contains].gsub(/[^0-9a-z ]/i, '')#.upcase
      #@venues = Venue.where("regexp_replace(name, '[^0-9a-zA-Z ]', '') ilike '%#{searchterm}%'").collect {|v| { :label => "#{v.name} (#{v.address})", :value => "#{v.name} (#{v.address})", :id => v.id } }
      @venues = Parse::Query.new("Venue").regex("name", searchterm).get
      #raise @venues.to_yaml
      @venues = @venues.collect {|v| { :label => "#{v["name"]} (#{v["address"]})", :value => "#{v["name"]} (#{v["address"]})", :id => v["id"] } }
    else
      @venues = []
    end

    render json: @venues
  end



end
