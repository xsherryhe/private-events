class AddNotesToEventRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :event_registrations, :notes, :text
  end
end
