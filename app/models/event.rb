class Event < ApplicationRecord
  include StringParser
  before_validation :build_invitations
  belongs_to :creator, class_name: 'User'
  before_validation :set_happening_at
  validates :name, presence: true
  has_many :event_registrations, foreign_key: 'attended_event_id', dependent: :destroy
  has_many :attendees, through: :event_registrations
  has_many :invitations, foreign_key: 'invited_event_id', dependent: :destroy
  has_many :invitees, through: :invitations

  enum :privacy_status, [:public_event, :private_event], default: :public_event

  scope :order_by, (lambda do |sort|
    attribute, dir = {
      tsoon: %i(happening_at asc),
      tlate: %i(happening_at desc),
      name: %i(name asc),
      updated: %i(events.updated_at desc),
      created: %i(events.created_at desc)
    }[(sort || :tsoon).to_sym]
    
    if attribute == :happening_at
      order(Arel.sql("CASE WHEN happening_date IS NULL 
                          THEN events.updated_at
                          ELSE happening_at 
                          END #{dir.to_s}"))
    else
      order(attribute => dir)
    end
  end)

  scope :future, (lambda do
    where('happening_at >= ?', DateTime.current)
    .or(where(happening_date: nil)
       .where('happening_at >= ?', 
              Time.new(2000, 1, 1, Time.now.hour, Time.now.min, Time.now.sec, 0)))
    .or(where(happening_at: nil))
  end)

  scope :past, (lambda do
    where.not(happening_at: nil)
    .and(where.not(happening_date: nil)
              .where('happening_at < ?', DateTime.current)
         .or(where(happening_date: nil)
             .where('happening_at < ?', Time.new(2000, 1, 1, Time.now.hour, Time.now.min, Time.now.sec, 0))))
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

  private

  def set_happening_at
    self.happening_at = 
      if happening_date && happening_time
        DateTime.new(happening_date.year, happening_date.month, happening_date.day,
                     happening_time.hour, happening_time.min, happening_time.sec)
      elsif happening_date
        happening_date.to_datetime
      elsif happening_time
        happening_time.to_datetime
      else nil
      end
  end
end
