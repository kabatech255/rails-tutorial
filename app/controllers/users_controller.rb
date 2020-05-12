class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '登録に成功しました'
      log_in @user
      # ↓redirect_to user_url(@user)と等価。user_urlとは、「 /users/:id」で、rails routesでPrefixを確認するとわかる
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
