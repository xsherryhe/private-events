class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @curr_user = current_user
    @attended_events = @user.attended_events
  end
end
