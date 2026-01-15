class GuestRegistrationsController < ApplicationController
  def new
    redirect_to root_path unless current_user.guest?
    @user = current_user
  end

  def create
    @user = current_user
    return redirect_to root_path unless @user.guest?

    if @user.update(upgrade_params.merge(guest: false))
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def upgrade_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
