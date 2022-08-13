class AddPrivacyStatusToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :privacy_status, :integer
  end
end
