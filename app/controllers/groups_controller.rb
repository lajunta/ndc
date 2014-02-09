# -*- encoding : utf-8 -*-
class GroupsController < ApplicationController
  before_action :root_required
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:new,:edit]
  before_action :only=>["create","update"] do
    logo_check("group") 
  end

  before_action :check_admin, only: [:edit,:update,:destroy]

  def check_admin
    if @group.admin!=realname
      redirect_to :back, flash: {error: "你不能操作这个群组"}
    end
  end
  def search
    @groups=Group.where(name: /#{params[:sstr]}/).page  params[:page]
    render :index
  end

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.page params[:page]
  end

  def type
    @groups = Group.where(type: params[:type]).page params[:page]
    render :index
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @students=Student.where(default_group: @group.name)
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.type ||= "班级"
    @group.admin ||= realname
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: '组织创建成功' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: '组织更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_type
      @type=['班级','社团','部门','科组']
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :type, :homepage, :intro, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
