class AddViewedAtToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :viewed_at, :datetime
  end
end
