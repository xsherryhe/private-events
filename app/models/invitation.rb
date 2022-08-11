class Invitation < ApplicationRecord
  belongs_to :invited_event, class_name: 'Event'
  belongs_to :invitee, class_name: 'User'
end
