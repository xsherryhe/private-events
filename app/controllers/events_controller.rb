class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @events = Event.all
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      current_user.attended_events << @event
      flash[:notice] = "Successfully created event \"#{@event.name}\"!"
      redirect_to current_user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot edit this event as you are not the host.'
      redirect_to @event
    end
  end

  def update
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot edit this event as you are not the host.'
      redirect_to @event
    end

    if @event.update(event_params)
      flash[:notice] = "Successfully updated event \"#{@event.name}\"!"
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    unless @event.creator == current_user
      flash[:error] = 'You cannot delete this event as you are not the host.'
      redirect_to @event
    end

    name = @event.name
    @event.destroy
    flash[:notice] = "Successfully deleted event \"#{name}\"."
    redirect_to current_user, status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:name, 
                                  :happening_date, 
                                  :happening_time,
                                  :location, 
                                  :description)
  end
end
