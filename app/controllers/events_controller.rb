class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @venue_names = Venue.all_venues

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
    @venue_names = Venue.all_venues

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @venue_names = Venue.all_venues
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    @venue_names = Venue.all_venues

    respond_to do |format|
      if @event.save
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
    @event.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    params[:event][:price] = params[:event][:price].to_f
    params[:event][:reportFlag] = params[:event][:reportFlag].to_f
    params[:event][:endDate] = params[:event][:endDate].to_date
    params[:event][:startDate] = params[:event][:startDate].to_date

    if params[:venue_id]
      venue = Parse::Query.new("Venue").eq("objectId", params[:venue_id]).get.first
      params[:event][:venue]=venue.pointer
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
end
