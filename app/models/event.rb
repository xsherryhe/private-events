class Event < ApplicationRecord
  validates :name, presence: true
  belongs_to :creator, class_name: "User"
  has_many :event_registrations, foreign_key: "attended_event_id", dependent: :destroy
  has_many :attendees, through: :event_registrations
  has_many :invitations, foreign_key: "invited_event_id", dependent: :destroy
  has_many :invitees, through: :invitations

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
end
