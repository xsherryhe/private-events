class EventRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    if current_user.attended_events.include?(@event)
      flash[:page_registration_error] = "You have already registered for this event."
      redirect_to @event
    else
      @event_registration = current_user.event_registrations
                                        .build(attended_event_id: @event.id)
    end
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
      @event_registration.errors.add(:base, message: "You have already registered for this event.")
      render :new, status: :unprocessable_entity
    end
  end

  private
  
  def event_registration_params
    params.require(:event_registration).permit(:notes)
  end
end
