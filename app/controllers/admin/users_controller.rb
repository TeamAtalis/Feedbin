class Admin::UsersController < ApplicationController
  def index
    @users = if params.key?(:q)
      User.page(params[:page]).where("email ILIKE :query", query: "%#{params[:q]}%") + DeletedUser.page(params[:page]).where("email ILIKE :query", query: "%#{params[:q]}%")
    else
      User.page(params[:page]) + DeletedUser.page(params[:page])
    end
    render layout: "settings"
  end

  def destroy
    @user = User.find(params[:id])
    @user.deleted = true
    # we must delete first, because of foreign key constraints
    @user.r_users_profiles.destroy_all
    @user.destroy

    # old Stripe user deleter
    # UserDeleter.perform_async(@user.id)
  end

  def authorize
    unless current_user.try(:admin?)
      render_404
    end
  end
end
