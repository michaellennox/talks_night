# frozen_string_literal: true

module Groups
  class EventsController < ApplicationController
    layout 'group'

    before_action -> { set_group! }

    def index
      @upcoming_events = @group.upcoming_events
      @previous_events = @group.previous_events
    end

    def new
      raise AccessDeniedError unless @group.administered_by?(current_user)

      @event = Event.new(group: @group)
    end

    def create
      raise AccessDeniedError unless @group.administered_by?(current_user)

      @event = Event.new(event_params.merge(group: @group))

      if @event.save
        redirect_to group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @event = @group.events.find(params[:id])
    end

    private

    def set_group!
      @group = Group.find_by!(url_slug: params[:group_url_slug])
    end

    def event_params
      params
        .require(:event)
        .permit(:title, :description, :starts_at, :ends_at)
    end
  end
end
