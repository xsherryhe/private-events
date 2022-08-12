require_relative "20220811203831_add_attending_response_to_invitations"

class RemoveAttendingResponseFromInvitations < ActiveRecord::Migration[7.0]
  def change
    revert AddAttendingResponseToInvitations
  end
end
