class Invitation < ApplicationRecord
  belongs_to :invited_event, class_name: 'Event'
  belongs_to :invitee, class_name: 'User', optional: true
  before_validation :set_invitee, on: :create
  validates :invitee_username, presence: true, on: :create
  validate :valid_invitee, unless: -> { invitee_username.blank? }, on: :create

  enum :response, [:not_responded, :accepted, :declined], default: :not_responded

  attr_accessor :invitee_username

  private

  def set_invitee
    self.invitee_id = User.find_by(username: invitee_username)&.id
  end

  def valid_invitee
    return errors.add(:invitee_username, 'does not exist') unless invitee
    if invited_event.attendees.include?(invitee)
      errors.add(:invitee, 'has already registered for this event')
    elsif invited_event.invitees.include?(invitee)
      errors.add(:invitee, 'has already been invited')
    end
  end
end
