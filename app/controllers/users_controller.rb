class UsersController < ApplicationController

  before_action :set_user, only: [:show]
  before_action :signed_in_user, only: [:index, :show, :edit]
  #before_action :correct_user, only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @currentuser = current_user
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.where(:username => params[:username]).first
    if @user.nil?
      redirect_to users_path, :flash => {:error => sprintf("No such user!")} and return
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  #def edit
  #  @user = User.where(:username => params[:username]).first
  #end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {
          sign_in @user
          redirect_to users_path, notice: 'User was successfully created.'
        }
        format.json { render :nothing => true, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :bad_request }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  #def update
  #  respond_to do |format|
  #    if @user.set(user_params)
  #      format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: 'edit' }
  #      format.json { render json: @user.errors, status: :bad_request }
  #    end
  #  end
  #end

  def follow
    usertofollow = User.where(:username => params[:username]).first
    if usertofollow.nil?
      respond_to do |format|
        format.html {
          redirect_to users_path, :flash => {:error => sprintf("No such user!")} and return
        }
        format.json { render json: ["No such user!"], status: :bad_request and return }
      end

    end
    currentuser = current_user

    unless currentuser == usertofollow
      currentuser.follow(usertofollow)
      respond_to do |format|
        format.html {
          redirect_to users_path, :flash => {:info => sprintf("You are now following %s", usertofollow.username)} and return
        }
        format.json { render :nothing => true, status: :created, location: @user and return}
      end
    end
    respond_to do |format|
      format.html {
        redirect_to users_path, :flash => {:error => sprintf("You can't follow yourself!")} and return
      }
      format.json { render json: ["You can't follow yourself!"], status: :bad_request and return }
    end


  end

  def unfollow
    usertounfollow = User.where(:username => params[:username]).first
    if usertounfollow.nil?
      redirect_to users_path, :flash => {:error => sprintf("No such user!")} and return
    end
    currentuser = current_user

    unless currentuser == usertounfollow
      currentuser.unfollow(usertounfollow)
      redirect_to users_path, :flash => {:info => sprintf("You now stopped following %s", usertounfollow.username)} and return
    end
    redirect_to users_path, :flash => {:error => sprintf("You can't unfollow yourself because you can't even follow yourself!")} and return

  end

  # DELETE /users/1
  # DELETE /users/1.json
  #def destroy
  #  @user = User.where(:username => params[:username]).first
  #  @user.destroy
  #  respond_to do |format|
  #    format.html { redirect_to users_url }
  #    format.json { head :no_content }
  #  end
  #end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:id, :username, :password, :password_confirmation)
  end

end
