module ApplicationHelper
  def new_invitations_display
    count = current_user&.received_invitations&.not_viewed&.count
    count && count > 0 ? "(#{count} New)" : ''
  end
end
