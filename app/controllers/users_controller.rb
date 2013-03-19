class UsersController < ApplicationController
  before_filter :non_signed_in_user, only: [:new, :create]
  before_filter :signed_in_user,     only: [:index, :show, :edit, :update, :destroy]
  before_filter :correct_user,       only: [:show, :edit, :update]
  before_filter :admin_user,         only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user 
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])

    if current_user?(user) && current_user.admin?
      flash[:error] = "Woah there you can't do that!"
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  private

  def non_signed_in_user
    if signed_in?
      redirect_to root_path, notice: "You're already signed in as a member!"
    end
  end 

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) || current_user.admin?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end







