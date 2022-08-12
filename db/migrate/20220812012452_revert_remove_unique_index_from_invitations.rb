require_relative "20220812005451_remove_unique_index_from_invitations"

class RevertRemoveUniqueIndexFromInvitations < ActiveRecord::Migration[7.0]
  def change
    revert RemoveUniqueIndexFromInvitations
  end
end
