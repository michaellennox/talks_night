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

  def edit
    @group = Group.find_by!(url_slug: params[:url_slug])

    raise AccessDeniedError unless @group.administered_by?(current_user)
  end

  private

  def group_params
    params
      .require(:group)
      .permit(:description, :name)
      .merge(owner: current_user)
  end
end
