# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(@user)
      redirect_to login_return_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:display_name, :email, :password, :password_confirmation)
  end
end
