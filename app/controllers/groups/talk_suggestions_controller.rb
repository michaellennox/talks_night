# frozen_string_literal: true

module Groups
  class TalkSuggestionsController < ApplicationController
    layout 'group'

    before_action -> { set_group! }
    before_action -> { set_talk! }
    before_action -> do
      require_login(return_path: new_group_talk_suggestion_path(params[:group_url_slug], talk_id: params[:talk_id]))
    end
    before_action -> { require_speaker_is_current_user! }

    def new
      @talk_suggestion = TalkSuggestion.new(talk: @talk, group: @group)
    end

    def create
      @talk_suggestion = TalkSuggestion.new(talk_suggestion_params.merge(talk: @talk, group: @group))

      if @talk_suggestion.save
        redirect_to group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_group!
      @group = Group.find_by!(url_slug: params[:group_url_slug])
    end

    def set_talk!
      @talk = Talk.find(params[:talk_id])
    end

    def require_speaker_is_current_user!
      raise AccessDeniedError unless @talk.speaker == current_user
    end

    def talk_suggestion_params
      params
        .require(:talk_suggestion)
        .permit(:speaker_contact)
    end
  end
end
