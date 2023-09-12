module ApplicationHelper
  include Pagy::Frontend
  
  def full_title(page_title)
    base_title = current_user&.admin? ? t("title.admin") : t("title.user")
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def alert_class_for(flash_type)
    case flash_type.to_sym
    when :success
      "alert-success"
    when :error, :alert
      "alert-danger"
    when :warning, :notice
      "alert-warning"
    when :info
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def status_badge(status)
    case status.to_sym
    when :wait_confirm
      "warning"
    when :delivering
      "primary"
    when :completed
      "success"
    else
      "danger"
    end
  end

  def category_selection
    Category.all.map {|category| [category.name, category.id] }
  end

  def status_order_selection
    Order.statuses.keys.map { |key| [t("display.order_status.#{key}"), key] }
  end
  
  def has_image(item)
    item.image.attached?
  end

  def total_cart(prodcuts)
    prodcuts.sum { |product| product.price * @cart_items[product.id.to_s] }
  end

  def link_not_receive_unlock?
    devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) &&
                                controller_name != "unlocks"
  end

  def link_not_receive_confirm?
    devise_mapping.confirmable? && controller_name != "confirmations"
  end

  def link_forgot_password?
    devise_mapping.recoverable? && controller_name != "passwords" &&
                                  controller_name != "registers"
  end

  def link_sign_up?
    devise_mapping.registerable? && controller_name != "registers"
  end

  def link_sessions?
    controller_name != "sessions"
  end
end
