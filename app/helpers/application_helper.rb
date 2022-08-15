module ApplicationHelper
  def new_invitations_string
    count = current_user&.received_invitations&.not_viewed&.count
    count && count > 0 ? "<br />(#{count} New)" : false
  end
end
