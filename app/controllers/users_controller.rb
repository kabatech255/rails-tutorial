class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = '更新に成功しました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    deleteUser = User.find(params[:id])
    deletedName = deleteUser.name
    deleteUser.destroy
    flash[:success] = "User #{deletedName} deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # 正しいユーザー(=編集や削除などの権限がある、または本人である)かどうか
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
