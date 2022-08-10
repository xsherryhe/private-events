class Event < ApplicationRecord
  validates :name, presence: true
  validates :happening_hour, numericality: { only_integer: true,
                                             in: 1..12,
                                             message: "must be an integer between 1 and 12" },
                             unless: -> { happening_hour.blank? }
  validates :happening_minute, numericality: { only_integer: true,
                                               in: 0..59,
                                               message: "must be an integer between 0 and 59"},
                               unless: -> { happening_minute.blank? }
  validates :happening_ampm, inclusion: { in: %w(AM PM),
                                          message: "must be either AM or PM" },
                             unless: -> { happening_ampm.blank? }
  after_validation :parse_happening_at
  belongs_to :creator, class_name: "User"

  attr_accessor :happening_date, :happening_hour, :happening_minute, :happening_ampm

  private

  def happening_attributes
    [happening_date, happening_hour, happening_minute, happening_ampm]
  end

  def parse_happening_at
    if happening_attributes.none?(&:blank?)
      happening_24_hour = Time.strptime("#{happening_hour} #{happening_ampm}", '%I %P').hour
      self.happening_at = happening_date + 
                          happening_24_hour.hours +
                          happening_minute.to_i.minutes
    end
  end
end
