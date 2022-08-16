
function enableAttendeeNotesLinks() {
  document.querySelectorAll('.event-details .attendee-notes-link').forEach(link => {
    link.addEventListener('click', toggleRegistrationNotes);
  })
}
document.addEventListener('turbo:load', () => enableAttendeeNotesLinks());

function toggleRegistrationNotes(e) {
  e.target.nextElementSibling.classList.toggle('hidden');
}
