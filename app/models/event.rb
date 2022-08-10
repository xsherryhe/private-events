class Event < ApplicationRecord
  validates :name, presence: true
  belongs_to :creator, class_name: "User"
  has_many :event_registrations, foreign_key: "attended_event_id"
  has_many :attendees, through: :event_registrations
end
