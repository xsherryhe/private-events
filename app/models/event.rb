class Event < ApplicationRecord
  include StringParser
  before_validation :build_invitations
  validates :name, presence: true
  belongs_to :creator, class_name: 'User'
  has_many :event_registrations, foreign_key: 'attended_event_id', dependent: :destroy
  has_many :attendees, through: :event_registrations
  has_many :invitations, foreign_key: 'invited_event_id', dependent: :destroy
  has_many :invitees, through: :invitations

  enum :privacy_status, [:public_event, :private_event], default: :public_event

  scope :future, (lambda do
    where('happening_date > ?', Date.current)
   .or(where(happening_date: Date.current).where('happening_time >= ?', Time.current))
   .or(where(happening_date: Date.current).where(happening_time: nil))
   .or(where(happening_date: nil))
  end)

  scope :past, (lambda do
    where('happening_date < ?', Date.current)
   .or(where(happening_date: Date.current).where('happening_time < ?', Time.current))
  end)

  scope :not_responded_invitation, (lambda do |invitee|
    joins(:invitations).where(invitations: { invitee_id: invitee.id, 
                                             response: :not_responded })
  end)

  attr_accessor :invitee_usernames

  def full_access?(user)
    public_event? ||
      creator == user ||
      (attendees + invitees).include?(user)
  end

  def build_invitations
    parse_list(invitee_usernames).each do |invitee_username|
      invitations.build(invitee_username: invitee_username)
    end
  end
end
