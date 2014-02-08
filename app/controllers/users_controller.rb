# -*- encoding : utf-8 -*-
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

  def upload
    if request.post?
      require "spreadsheet"
      @file=params[:xls]
      unless @file
        flash[:error]="选择一个文件" 
        redirect_to :back and return
      end 
      #login realname password default_group
      book = Spreadsheet.open @file.tempfile
      sheet1 = book.worksheet 0
      right=wrong=updated=0
      existed=[]
      sheet1.each 1 do |row|
        old_user=User.where(login: row[0],realname: row[1]).first
        if old_user
          existed<<row[1]
          old_user.login=row[0]
          old_user.realname=row[1]
          old_user.password=row[2].to_i.to_s
          old_user.password_confirmation=row[2].to_i.to_s
          old_user.default_group=row[3]
          old_user.type=row[4]
          if old_user.save 
            updated+=1
          end
        else
          #randpsd=Random.new.rand(1000..9999)
          new_user=User.new({login: row[0].to_s.strip,realname: row[1].strip,password: row[2].to_i.to_s.strip,password_confirmation:row[2].to_i.to_s.strip,default_group: row[3].strip,type: row[4].strip})
          new_user.save ? right+=1 : wrong+=1
        end 
      end 
      word="输入成功#{right},已经存在#{existed},更新#{updated}, 失败#{wrong}"
      flash[:notice]=word
      redirect_to users_path and return
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
    @user.default_group = "全体"
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
      params.require(:user).permit(:login, :password,:default_group, :password_confirmation, :type,:realname, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
