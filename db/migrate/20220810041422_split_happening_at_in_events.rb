class SplitHappeningAtInEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :happening_at, :datetime
    add_column :events, :happening_date, :date
    add_column :events, :happening_time, :time
  end
end
