class EventRegistration < ApplicationRecord
  belongs_to :attendee, class_name: 'User'
  belongs_to :attended_event, class_name: 'Event'

  after_save :accept_invitation

  private

  def accept_invitation
    return unless attendee.invited_events.include?(attended_event)

    invitation = attendee.received_invitations.find_by(invited_event_id: attended_event.id)
    invitation.accepted!
  end
end
