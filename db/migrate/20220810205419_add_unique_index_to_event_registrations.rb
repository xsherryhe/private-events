class AddUniqueIndexToEventRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_index :event_registrations, [:attendee_id, :attended_event_id], unique: true
  end
end
