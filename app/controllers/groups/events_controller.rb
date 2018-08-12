# frozen_string_literal: true

module Groups
  class EventsController < ApplicationController
    layout 'group'

    before_action -> { set_group! }

    def new
      raise AccessDeniedError unless @group.administered_by?(current_user)

      @event = Event.new(group: @group)
    end

    private

    def set_group!
      @group = Group.find_by!(url_slug: params[:group_url_slug])
    end
  end
end
