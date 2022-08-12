module InvitationsHelper
  def strong_unless_viewed(invitation, &block)
    unless invitation.viewed?
      content_tag(:strong, capture(&block))
    else
      block.call
    end
  end
end
