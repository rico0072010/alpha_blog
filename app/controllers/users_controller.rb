class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :require_same_user, only: %i[edit update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:danger] = 'User and all articles created by user have been deleted'
    redirect_to users_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the alpha blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update
      flash[:success] = 'Account successfully updated'
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if (current_user != @user) && !current_user.admin?
      flash[:danger] = 'You can only edit your account'
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = 'Only admin users can perform that action'
      redirect_to root_path
    end
  end
end
