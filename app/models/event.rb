class Event < ApplicationRecord
  validates :name, presence: true
  belongs_to :creator, class_name: "User"
end
