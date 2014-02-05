class UsersController < ApplicationController
  before_action :login_required
  before_action :root_required, only: [:index,:search,:new]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:new,:edit]
  before_action :only=>["create","update"] do
    logo_check("user") 
  end

  before_action :check_user, only: [:edit,:update,:destroy]

  def check_user
    unless is_root? or @user.realname==realname
      redirect_to :back, flash: {error: "你不能操作别人的东西"}
    end
  end

  def settings
    @user=User.find(user_id)
    @config = @user.config ||= {}
    if request.xhr?
      @user.config['fav_courses'] = params[:fav_courses] 
      @user.config['fav_banjis'] = params[:fav_banjis] 
      @user.config['fav_crooms'] = params[:fav_crooms] 
      @user.update_attribute(:config,@user.config)
      respond_to do |form|
        form.js { render :layout=>false}
      end
    end
  end

  def set_type
    @type=["教师","学生"]
  end

  def search
    @users=User.where(login: /#{params[:sstr]}/).page  params[:page]
    render :index
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page params[:page]
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.type ||= '学生'
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: '用户创建成功' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: '用户更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if session[:user_id] == params[:id] or is_root?
        @user = User.find(params[:id])
      else
        redirect_to root_path ,notice: '你不是你' and return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:login, :password, :password_confirmation, :type,:realname, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
