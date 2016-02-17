require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  responders :flash, :http_cache

  protect_from_forgery :with => :exception
  before_filter :sidebar

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  #checkin error handling
  #just need to fix routing for this and user // participant creation flow/path
  rescue_from 'Participant::NotRegistered' do |exception|
    flash[:notice] = "The Student ID you swiped is not yet activated with a user account. Please register with andrew eMail"
    #Event.new_event "Exception: #{exception.message}", current_user, request.remote_ip #deugging
    redirect_to "/participants/new"
  end

  rescue_from 'CheckoutsController::CheckoutError' do |exception|
    flash.now[:error] = exception.message
    #Event.new_event "Exception: #{exception.message}", current_user, request.remote_ip #deugging
    respond_to do |format|
      format.html { redirect_to "/tools" }
      format.json { render :json => exception.message, :status => :unprocessable_entity }
    end
  end

  rescue_from 'RestClient::Forbidden' do |exception|
    flash[:error] = "Cannot connect to CMU Authentication"
    #Event.new_event "Exception: #{exception.message}", current_user, request.remote_ip #deugging
    redirect_to "/"
  end

  def participant_already_in_system(participant)
    flash[:notice] = "The participant is already in the system - Update organizations for #{participant.name}"
  end
  
  def sidebar
    @current_shifts_sidebar = Shift.current
    @upcoming_shifts_sidebar = Shift.upcoming
    @tasks_sidebar = Task.upcoming
    @structural_queue_sidebar = OrganizationTimelineEntry.structural.current
    @electrical_queue_sidebar = OrganizationTimelineEntry.electrical.current
    @checkouts_sidebar = Checkout.current
    @downtime_sidebar = OrganizationTimelineEntry.downtime.current
  end

  def require_authenticated_user
    if current_user.nil?
      redirect_to main_app.user_omniauth_authorize_path(:shibboleth)
    end
  end
end
