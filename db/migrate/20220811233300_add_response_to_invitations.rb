class AddResponseToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :response, :integer
  end
end
