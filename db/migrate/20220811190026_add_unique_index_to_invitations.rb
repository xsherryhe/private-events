class AddUniqueIndexToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_index :invitations, [:invitee_id, :invited_event_id], unique: true
  end
end
