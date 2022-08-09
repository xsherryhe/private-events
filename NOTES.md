Data models

User
-username, presence: true, uniqueness: true, authentication key
-email, presence: true, uniqueness: true, authentication key
-password, presence: true, includes upcase downcase num symbol, min 6 chars
has_many :hosted_events, class_name: Event, foreign_key: "host_id"
has_many :event_registrations
has_many :attending_events, through: :event_registrations, foreign_key: "attendee_id"

EventRegistration
belongs_to :attendee, class_name: User
belongs_to :event

Event
-name, presence: true
-datetime
-location
-description
belongs_to :host, class_name: User
has_many :attendees, through: :event_registrations
