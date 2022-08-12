class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_\.#$!*?]*\Z/, 
                                 message: 'contains a disallowed character' }
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?]).*\Z/,
                                 message: "must contain at least 1 of each: " \
                                          "uppercase letter, lowercase letter, digit, symbol" },
                       allow_blank: true
  has_many :created_events, class_name: "Event", foreign_key: "creator_id", dependent: :destroy
  has_many :event_registrations, foreign_key: "attendee_id", dependent: :destroy
  has_many :attended_events, through: :event_registrations
  has_many :created_invitations, through: :created_events, source: :invitations
  has_many :received_invitations, class_name: 'Invitation', foreign_key: "invitee_id", dependent: :destroy
  has_many :invited_events, through: :received_invitations

  scope :not_responded_invitation, (lambda do |invited_event|
    joins(:received_invitations).where(received_invitations: { invited_event_id: invited_event.id, 
                                       response: :not_responded })
  end)
  
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    %i(email username).each do |attribute|
      conditions[attribute].downcase! if conditions[attribute]
    end
    if(login = conditions.delete(:login))
      where(conditions.to_h).where(["username = :value OR email = :value", 
                                    { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
