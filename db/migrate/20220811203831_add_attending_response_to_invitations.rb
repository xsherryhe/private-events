class AddAttendingResponseToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :attending_response, :boolean, null: true
  end
end
