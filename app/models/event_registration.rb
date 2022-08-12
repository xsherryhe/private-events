class EventRegistration < ApplicationRecord
  belongs_to :attendee, class_name: 'User'
  belongs_to :attended_event, class_name: 'Event'

  after_create :accept_invitation
  before_destroy :unaccept_invitation

  private

  def has_invitation?
    attendee.invited_events.include?(attended_event)
  end

  def invitation
    attendee.received_invitations.find_by(invited_event_id: attended_event.id)
  end

  def accept_invitation
    return unless has_invitation?
    invitation.accepted!
  end

  def unaccept_invitation
    return unless has_invitation?
    invitation.not_responded!
  end
end
