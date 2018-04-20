# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :require_login, only: %i[new create]

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

  def show; end

  private

  def require_login
    return if current_user

    session[:return_path] = new_group_path
    redirect_to new_user_path
  end

  def group_params
    params
      .require(:group)
      .permit(:description, :name)
      .merge(owner: current_user)
  end
end
