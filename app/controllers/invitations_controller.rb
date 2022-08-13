class InvitationsController < ApplicationController
  include StringParser
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot invite users to this event as you are not the host.'
      redirect_to @event
    end

    @invitations = []
    @sample_invitation = @event.invitations.build
  end

  def create
    @event = Event.find(params[:event_id])
    invitee_usernames_arr = parse_list(invitee_usernames_param)
    @invitations = (invitee_usernames_arr.empty? ? [''] : invitee_usernames_arr).map do |invitee_username|
      @event.invitations.build(invitation_params.merge(invitee_username: invitee_username))
    end
    @sample_invitation = @invitations.first

    begin
      if @invitations.map(&:save).all?
        flash[:notice] = "Successfully sent invite#{@invitations.size == 1 ? '' : 's'} for event \"#{@event.name}\"!"
        redirect_to @event
      else
        rollback_create
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      rollback_create
      @invitations.select { |invitation| Invitation.find_by(invited_event: @event, invitee: invitation.invitee) }
                  .each { |invitation| invitation.errors.add(:invitee, "#{invitation.invitee_username} has already been invited") }
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @invitations = current_user.received_invitations.includes(invited_event: :creator)
  end

  def show
    @invitation = Invitation.includes({ invited_event: :creator }, :invitee).find_by(id: params[:id])
    @invitation.viewed! unless @invitation.viewed?
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
    params.require(:invitation).permit(:notes, :response)
  end

  def invitee_usernames_param
    params.require(:invitations).permit(:invitee_usernames)['invitee_usernames']
  end

  def rollback_create
    invitee_usernames_arr = []
    @invitations.select(&:persisted?).each do |invitation| 
      invitee_usernames_arr << invitation.invitee_username
      invitation.destroy
    end
    @invitee_usernames = invitee_usernames_arr.join(', ')
  end
end
