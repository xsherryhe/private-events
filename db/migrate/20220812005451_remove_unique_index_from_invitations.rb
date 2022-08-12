require_relative "20220811190026_add_unique_index_to_invitations"

class RemoveUniqueIndexFromInvitations < ActiveRecord::Migration[7.0]
  def change
    revert AddUniqueIndexToInvitations
  end
end
