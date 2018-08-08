# frozen_string_literal: true

module Groups
  class TalksController < ApplicationController
    layout 'group'

    before_action -> { set_group! }
    before_action -> { require_login(return_path: new_group_talk_path(params[:group_url_slug])) }

    def new
      @talk = Talk.new
    end

    def create
      @talk = Talk.new(talk_params.merge(speaker: current_user))

      if @talk.save
        redirect_to new_group_talk_suggestion_path(@group, talk_id: @talk.id)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_group!
      @group = Group.find_by!(url_slug: params[:group_url_slug])
    end

    def talk_params
      params
        .require(:talk)
        .permit(:title, :description)
    end
  end
end
