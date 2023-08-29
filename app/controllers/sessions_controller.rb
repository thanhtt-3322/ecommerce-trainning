class SessionsController < ApplicationController
  include SessionsAction

  before_action :load_categories, only: :new 

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      sign_in user
      flash[:success] = t("sign_in.success_message")
      redirect_back_or user.admin? ? admin_home_path : root_path
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
