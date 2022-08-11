class EditColumnsInInvitations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :invitations, :creator, null: false, foreign_key: { to_table: :users }
    remove_reference :invitations, :event, null: false, foreign_key: true
    add_reference :invitations, :invited_event, null: false, foreign_key: { to_table: :events }
  end
end
