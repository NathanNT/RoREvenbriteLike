class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @admin_events = Event.where(admin_id: @user.id)
    (@admin_events.size > 0)? (@admin = true) : (@admin = false)
    @guest_events = Event.joins(:attendances).where('attendances.user_id = ?', @user.id)
    (@guest_events.size > 0)? (@guest = true) : (@guest = false)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(first_name: params[:first_name], 
                    last_name: params[:last_name],
                    description: params[:description],
                    email: params[:mail])
    if params[:password] != params[:confirmpassword]
      flash.now[:danger] = "Passwords must match !"
      render :action => 'new' 
    end
    if @user.save # essaie de sauvegarder en base @gossip
        flash[:success] = "You successfuly created your account"
        redirect_to :controller => 'users', :action => 'index'
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      flash.now[:danger] = "Error with the account creation"
      render :action => 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end

end















