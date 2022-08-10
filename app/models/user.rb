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
                       unless: -> { password.nil? }
  
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    [:email, :username].each do |attribute|
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
