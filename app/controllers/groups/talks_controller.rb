# frozen_string_literal: true

module Groups
  class TalksController < ApplicationController
    layout 'group'

    before_action -> { set_group! }
    before_action -> { require_login(return_path: new_group_talk_path(params[:group_url_slug])) }, only: %i[new create]

    def new; end

    def create; end

    private

    def set_group!
      @group = Group.find_by!(url_slug: params[:group_url_slug])
    end
  end
end
