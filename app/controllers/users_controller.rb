class UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:new, :create, :destroy]


  def index
    @title = "All OPH Staff"
    if params[:search]
      @users = User.where('lower(name) LIKE ?', "%#{params[:search].downcase.strip}%").paginate(:page => params[:page])
    else
      @users = User.where(:locked => false).order("name").paginate(:page => params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Add a Staff Account"
  end
  
  def create
    @user = User.new
    @user.accessible = :all if current_user.admin?
    @user.attributes = params[:user]
    @user.email.downcase!
    if @user.save
      flash[:success] = "Account created for " + @user.name
      redirect_to users_path
    else
      @title = "Add a Staff Account"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit Profile"
  end

  def update
    params[:user][:email].downcase!
    @user.accessible = :all if current_user.admin?
    if @user.update_attributes(params[:user])
      @user.update_attribute(:lastverified, Time.now)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit Profile"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user?(@user) || current_user.admin?)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end




end
