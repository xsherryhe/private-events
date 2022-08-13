module ApplicationHelper
  def strong_if_condition(condition, &block)
    if condition
      content_tag(:strong, capture(&block))
    else
      block.call
    end
  end

  def new_invitations_string
    count = current_user&.received_invitations&.not_viewed&.count
    count && count > 0 ? "(#{count} New)" : false
  end

  def parse_list(list)
    list.empty? ? [''] : list.split(/, */)
  end
end
