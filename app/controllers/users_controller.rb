class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @curr_user = current_user
    @sort = sort_params || {}
    @attended_events = @user.attended_events
  end

  private

  def sort_params
    params[:sort]&.permit(:created, :future, :invited, :past)
  end
end
