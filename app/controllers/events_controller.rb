class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @events = Event.all
    @curr_user = current_user
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      current_user.attended_events << @event
      flash[:notice] = "Successfully created event \"#{@event.name}\"!"
      redirect_to current_user
    else
      set_valid_invitee_usernames
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot edit this event as you are not the host.'
      redirect_to @event
    end
  end

  def update
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot edit this event as you are not the host.'
      redirect_to @event
    end

    begin
      if @event.update(event_params)
        flash[:notice] = "Successfully updated event \"#{@event.name}\"!"
        redirect_to @event
      else
        set_valid_invitee_usernames
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      @event.invitations.select { |invitation| invitation.new_record? && Invitation.find_by(invited_event: @event, invitee: invitation.invitee) }
                        .each { |invitation| invitation.errors.add(:invitee, "#{invitation.invitee_username} has already been invited") }
      set_valid_invitee_usernames
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    @creator = @event.creator
    @attendees = @event.attendees
  end

  def destroy
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot delete this event as you are not the host.'
      redirect_to @event, status: :see_other
    end

    name = @event.name
    @event.destroy
    flash[:notice] = "Successfully deleted event \"#{name}\"."
    redirect_to current_user, status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:name, 
                                  :happening_date, 
                                  :happening_time,
                                  :location,
                                  :privacy_status,
                                  :invitee_usernames,
                                  :description)
  end

  def set_valid_invitee_usernames
    @invitee_usernames = @event.invitations
                               .select { |invitation| invitation.new_record? && invitation.errors.none? }
                               .map(&:invitee_username).join(', ')
  end
end
