class SessionsController < ApplicationController
  include SessionsAction

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      sign_in user
      flash[:success] = t("sign_in.success_message")
      redirect_back_or root_path
    else
      flash.now[:error] = t("sign_in.error_message")
      render :new
    end
  end

  def destroy
    sign_out
    flash[:notice] = t("sign_out.success_message")
    redirect_to root_path
  end
end
