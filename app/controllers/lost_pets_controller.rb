class LostPetsController < ApplicationController
  # GET /lost_pets
  # GET /lost_pets.json
  def index
    @lost_pets = LostPet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lost_pets }
    end
  end

  # GET /lost_pets/1
  # GET /lost_pets/1.json
  def show
    @lost_pet = LostPet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lost_pet }
    end
  end

  # GET /lost_pets/new
  # GET /lost_pets/new.json
  def new
    @lost_pet = LostPet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lost_pet }
    end
  end

  # GET /lost_pets/1/edit
  def edit
    @lost_pet = LostPet.find(params[:id])
  end

  # POST /lost_pets
  # POST /lost_pets.json
  def create
    @lost_pet = LostPet.new(params[:lost_pet])
    @lost_pet.coordinate = ParseGeoPoint.new :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f
    respond_to do |format|
      if @lost_pet.save
        format.html { redirect_to @lost_pet, notice: 'Lost pet was successfully created.' }
        format.json { render json: @lost_pet, status: :created, location: @lost_pet }
      else
        format.html { render action: "new" }
        format.json { render json: @lost_pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lost_pets/1
  # PUT /lost_pets/1.json
  def update
    @lost_pet = LostPet.find(params[:id])

    respond_to do |format|
      if @lost_pet.update_attributes(params[:lost_pet])
        format.html { redirect_to @lost_pet, notice: 'Lost pet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lost_pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lost_pets/1
  # DELETE /lost_pets/1.json
  def destroy
    @lost_pet = LostPet.find(params[:id])
    @lost_pet.destroy

    respond_to do |format|
      format.html { redirect_to lost_pets_url }
      format.json { head :no_content }
    end
  end
end
