module AuthorizationAction
  extend ActiveSupport::Concern

  def require_role_admin
    unless current_user&.admin?
      store_location
      flash[:alert] = "You do not have permission to do this!"
      redirect_to session_path
    end
  end
end
