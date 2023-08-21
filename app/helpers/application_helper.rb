module ApplicationHelper
  def full_title(page_title)
    base_title = t("base_title")
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
end
