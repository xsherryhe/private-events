Data models

User
-username, presence: true, uniqueness: true, authentication key
-email, presence: true, uniqueness: true, authentication key
-password, presence: true, includes upcase downcase num symbol, min 6 chars
has_many :created_events, class_name: Event, foreign_key: "creator_id"
has_many :event_registrations
has_many :attended_events, through: :event_registrations, foreign_key: "attendee_id"
has_many :created_invitations, class_name: Invitation, foreign_key: "creator_id"
has_many :received_invitations, class_name: Invitation, foreign_key: "invitee_id"
has_many :invited_events, through: :received_invitations, source: :event

EventRegistration
-notes
belongs_to :attendee, class_name: User
belongs_to :attended_event, class_name: Event

Event
-name, presence: true
-datetime
-location
-description
belongs_to :creator, class_name: User
has_many :event_registrations
has_many :attendees, through: :event_registrations, foreign_key: "attended_event_id"
has_many :invitations

Invitation
-notes
belongs_to :creator, class_name: User
belongs_to :invitee, class_name: User
belongs_to :event

Invitations function
-Host can send invite from event links
  -Host types invited user's username
-Invitee will see invited events on their own events page
  -Also a separate page for invitations
  -Parentheses for how many new invitations
  -Persistent message in header for new invitations until they are opened (become old) -- place in layout in same place as the edit account/sign out options
  -New vs old invitations can be scoped from Invitation model
