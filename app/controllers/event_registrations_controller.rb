class EventRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    if current_user.attended_events.include?(@event)
      flash[:error] = "You have already registered for this event."
      redirect_to @event
    end

    @event_registration = current_user.event_registrations
                                      .build(attended_event_id: @event.id)
  end

  def create
    @event = Event.find(params[:event_id])
    @event_registration = current_user.event_registrations
                                      .build(event_registration_params
                                             .merge(attended_event_id: @event.id))
    begin
      if @event_registration.save
        flash[:notice] = "Successfully registed for event \"#{@event.name}\"!"
        redirect_to @event
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "You have already registered for this event."
      redirect_to @event, status: :see_other
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @event_registration = EventRegistration.find_by(attendee_id: current_user.id, 
                                                    attended_event_id: @event.id)
    unless @event_registration
      flash[:error] = "You are not registered for this event."
      redirect_to @event
    end
  end

  def update
    @event = Event.find(params[:event_id])
    @event_registration = EventRegistration.find_by(attendee_id: current_user.id, 
                                                    attended_event_id: @event.id)
    unless @event_registration
      flash[:error] = "You are not registered for this event."
      redirect_to @event
    end

    if @event_registration.update(event_registration_params)
      flash[:notice] = "Successfully updated registration for \"#{@event.name}\"!"
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event_registration = EventRegistration.find_by(attendee_id: current_user.id, 
                                                    attended_event_id: @event.id)
    unless @event_registration
      flash[:error] = "You are not registered for this event."
      redirect_to @event, status: :see_other
    end

    @event_registration.destroy
    flash[:notice] = "Successfully unregistered from event \"#{@event.name}\"."
    redirect_to @event, status: :see_other
  end

  private
  
  def event_registration_params
    params.require(:event_registration).permit(:notes)
  end
end
