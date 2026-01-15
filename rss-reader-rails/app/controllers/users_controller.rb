class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    unless @user.authenticate(params[:user][:current_password])
      flash.now[:alert] = "Current password is incorrect"
      render :edit, status: :unprocessable_entity
      return
    end

    if params[:user][:email_address].present?
      update_email
    elsif params[:user][:password].present?
      update_password
    else
      flash.now[:alert] = "No changes were made"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def update_email
    if @user.update(email_address: params[:user][:email_address])
      redirect_to edit_user_path, notice: "Email address updated successfully"
    else
      flash.now[:alert] = "Failed to update email address"
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      @user.sessions.where.not(id: Current.session.id).destroy_all
      redirect_to edit_user_path, notice: "Password updated successfully. Other sessions have been signed out."
    else
      flash.now[:alert] = "Failed to update password"
      render :edit, status: :unprocessable_entity
    end
  end
end
