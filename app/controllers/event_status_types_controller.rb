class EventStatusTypesController < ApplicationController
  before_action :set_event_status_type, only: [:show, :edit, :update, :destroy]

  # GET /event_status_types
  # GET /event_status_types.json
  def index
    @event_status_types = EventStatusType.all
  end

  # GET /event_status_types/1
  # GET /event_status_types/1.json
  def show
  end

  # GET /event_status_types/new
  def new
    @event_status_type = EventStatusType.new
  end

  # GET /event_status_types/1/edit
  def edit
  end

  # POST /event_status_types
  # POST /event_status_types.json
  def create
    @event_status_type = EventStatusType.new(event_status_type_params)

    respond_to do |format|
      if @event_status_type.save
        format.html { redirect_to @event_status_type, notice: 'Event status type was successfully created.' }
        format.json { render :show, status: :created, location: @event_status_type }
      else
        format.html { render :new }
        format.json { render json: @event_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_status_types/1
  # PATCH/PUT /event_status_types/1.json
  def update
    respond_to do |format|
      if @event_status_type.update(event_status_type_params)
        format.html { redirect_to @event_status_type, notice: 'Event status type was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_status_type }
      else
        format.html { render :edit }
        format.json { render json: @event_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_status_types/1
  # DELETE /event_status_types/1.json
  def destroy
    @event_status_type.destroy
    respond_to do |format|
      format.html { redirect_to event_status_types_url, notice: 'Event status type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_status_type
      @event_status_type = EventStatusType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_status_type_params
      params.require(:event_status_type).permit(:is_active, :name)
    end
end
