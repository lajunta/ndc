# -*- encoding : utf-8 -*-
class HubsController < ApplicationController
  before_action :teacher_required
  before_action :set_hub, only: [:package, :show, :edit, :update, :destroy]

  # GET /hubs
  # GET /hubs.json
  def index
    @hubs = Hub.or({users: realname},{creator: realname},{groups: default_group}).desc(:created_at).page params[:page]
  end

  def remove_attach
    grid.delete(params[:grid_id])
    @hub=Hub.find(params[:hub_id])
    attachs=@hub.attachs.delete_if{|a| a["grid_id"]==params[:grid_id]}
    if @hub.update_attribute(:attachs,attachs)
      respond_to do |form|
        form.js {render :layout=>false}
      end
    end
  end

  def package
    if @hub.submissions.blank?
      redirect_to :back , flash: {error: "还没有人上交"} and return
    end
    require "zip"
    require "stringio"
    filename=@hub.name+".zip"
    user_agent = request.user_agent.downcase
    filename = user_agent.include?("msie") ? CGI::escape(filename) :  filename
    stringio=StringIO.new ""
    stringio=Zip::OutputStream.write_buffer do |zio|
      @hub.submissions.each do |sub|
        sub.attachs.each do |attach|
          zio.put_next_entry(sub.submitter+"_"+attach["filename"])
          zio.write grid.get(attach["grid_id"]).data
        end
      end
    end
    stringio.rewind
    data = stringio.sysread
    send_data data, :type => 'application/x-zip', :disposition => 'attachment', :filename => filename
  end

  # GET /hubs/1
  # GET /hubs/1.json
  def show
    @sub_count=@hub.submissions.count
    if @hub.open
      @submissions=@hub.submissions
    else
      @submissions=@hub.submissions.where(submitter: realname)
      if @submissions.count==0
        redirect_to hubs_path, flash: {error: "你还没有上交"}
      end
    end
  end

  # GET /hubs/new
  def new
    @hub = Hub.new
    @hub.groups_list ||= "全体"
  end

  # GET /hubs/1/edit
  def edit
  end

  # POST /hubs
  # POST /hubs.json
  def create
    @hub = Hub.new(hub_params)

    respond_to do |format|
      if @hub.save
        format.html { redirect_to hubs_path, notice: '文件收集创建成功' }
        format.json { render action: 'show', status: :created, location: @hub }
      else
        format.html { render action: 'new' }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hubs/1
  # PATCH/PUT /hubs/1.json
  def update
    respond_to do |format|
      if @hub.update(hub_params)
        format.html { redirect_to hubs_path, notice: '文件收集更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hubs/1
  # DELETE /hubs/1.json
  def destroy
    attachs=@hub.attachs
    rm_grid_from_array(attachs)
    @hub.destroy
    respond_to do |format|
      format.html { redirect_to hubs_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hub
    @hub = Hub.find(params[:id])
    unless @hub
      redirect_to :back ,flash: {error: "没有这个记录"}
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def hub_params
    params[:hub][:creator]=realname
    params[:hub][:users_list]||=realname
    params[:hub][:groups_list]||="全体"
    params.require(:hub).permit(:name, :open, :desc, :creator, :end_on, :users_list, :groups_list).tap do |hub|
      unless params[:hub][:attachs].blank?
        @attachs=[]
        attachs=params[:hub][:attachs]
        attachs.each {|attach| @attachs<<uploadtogrid(attach)}
        @attachs = @hub.attachs.to_a+@attachs if params[:action]=="update"
        hub[:attachs]=@attachs
      end
    end
  end
end
