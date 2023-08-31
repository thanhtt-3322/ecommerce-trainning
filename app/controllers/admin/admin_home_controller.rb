class Admin::AdminHomeController < ApplicationController
  include AuthorizationAction

  before_action :authenticate_user
  before_action :require_role_admin

  def index; end
end
