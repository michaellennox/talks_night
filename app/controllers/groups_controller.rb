# frozen_string_literal: true

class GroupsController < ApplicationController
  layout 'group', except: %i[new create]

  before_action -> { require_login(return_path: new_group_path) }, only: %i[new create]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params.merge(owner: current_user))

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

  def update
    @group = Group.find_by!(url_slug: params[:url_slug])

    raise AccessDeniedError unless @group.administered_by?(current_user)

    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def group_params
    params
      .require(:group)
      .permit(:description, :name)
  end
end
