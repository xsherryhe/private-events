module EventsHelper
  def registration_notes(event, attendee)
    notes = event.event_registrations.find_by(attendee: attendee).notes
    notes unless notes.blank?
  end
end
