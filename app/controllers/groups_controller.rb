# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action -> { require_login(return_path: new_group_path) }, only: %i[new create]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to group_path(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @group = Group.find_by!(url_slug: params[:url_slug])
  end

  private

  def group_params
    params
      .require(:group)
      .permit(:description, :name)
      .merge(owner: current_user)
  end
end
