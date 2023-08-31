class OrderMailer < ApplicationMailer
  default from: "tran.trung.thanh@sun-asterisk.com"
  
  def confirm_order
    @order = params[:order]
    mail(to: @order.user.email, subject: t("mailer.subject.confirm_order"))
  end

  def place_order
    @order = params[:order]
    mail(to: @order.user.email, subject: t("mailer.subject.place_order"))
  end

  def reject_order
    @order = params[:order]
    @reason_description = @order.reason_description
    mail(to: @order.user.email, subject: t("mailer.subject.reject_order"))
  end
end
