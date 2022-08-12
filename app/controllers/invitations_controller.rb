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

  def index
    @invitations = current_user.received_invitations.includes(invited_event: :creator)
  end

  def show
    @invitation = Invitation.includes({ invited_event: :creator }, :invitee).find_by(id: params[:id])
    @invitation.update_viewed_at
  end

  def update
    @event = Event.find(params[:event_id])
    @invitation = Invitation.find_by(invitee_id: current_user.id,
                                     invited_event_id: @event.id)
    unless @invitation
      flash[:error] = "You don't have an invitation to this event."
      redirect_to @event
    end

    if @invitation.update(invitation_params)
      render :show, status: :see_other
    else
      flash[:error] = "Sorry, we ran into an error."
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @invitation = Invitation.find_by(invitee_id: current_user.id,
                                     invited_event_id: @event.id)
    unless @invitation
      flash[:error] = "You don't have an invitation to this event."
      redirect_to @event
    end

    @invitation.destroy
    flash[:notice] = "Successfully deleted invitation to \"#{@event.name}\"."
    redirect_to invitations_path, status: :see_other
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_username, :notes, :response)
  end
end
