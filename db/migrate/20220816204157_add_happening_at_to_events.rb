class AddHappeningAtToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :happening_at, :datetime
  end
end
