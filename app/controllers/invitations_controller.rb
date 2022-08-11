class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot invite users to this event as you are not the host.'
      redirect_to @event
    end

    @invitation = @event.invitations.build
  end

  def create
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.build(invitation_params)

    begin
      if @invitation.save
        flash[:notice] = "Successfully sent invite for event \"#{@event.name}\" to #{@invitation.invitee.username}!"
        redirect_to @event
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "User #{@invitation.invitee.username} has already been invited to this event."
      redirect_to @event, status: :see_other
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_username, :notes)
  end
end
