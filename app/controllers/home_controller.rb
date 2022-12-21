class HomeController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id) if user_signed_in?
  end

  def terms
  end

  def privacy
  end
end
