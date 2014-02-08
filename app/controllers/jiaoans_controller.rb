# -*- encoding : utf-8 -*-
class JiaoansController < ApplicationController
  before_action :teacher_required
  before_action :set_jiaoan, only: [:show, :edit, :update, :destroy]

  before_action :set_jiaoan_albums ,only: [:new,:edit]
  before_action :check_author ,only: [:update,:edit,:destroy]
  after_action  :unused_medias,:only=>["create","update"]

  def check_author
    unless is_root? or @jiaoan.author==realname
      redirect_to :back, flash: {error: "你不能进行操作"}
    end
  end

  def unused_medias
    if @unused.count>0
      @unused.each do |un|
        grid.delete(un['grid_id'])
      end
    end
    #clear user tempmedia medias []
    if @usertemps
      @usertemps.medias=[]
      @usertemps.save
    end
  end

  def set_jiaoan_albums
    @jiaoan_albums=JiaoanAlbum.where(creator: realname).page params[:page]
  end

  # GET /jiaoans
  # GET /jiaoans.json
  def index
    @jiaoan_album=JiaoanAlbum.find(params[:jiaoan_album_id])
    @jiaoans = @jiaoan_album.jiaoans
  end

  def remove_attach
    grid.delete(params[:grid_id])
    @jiaoan=Jiaoan.find(params[:ja_id])
    attachs=@jiaoan.attachs.delete_if{|a| a["grid_id"]==params[:grid_id]}
    if @jiaoan.update_attribute(:attachs,attachs)
      respond_to do |form|
        form.js {render :layout=>false}
      end
    end
  end

  # GET /jiaoans/1
  # GET /jiaoans/1.json
  def show
  end

  # GET /jiaoans/new
  def new
    @jiaoan_album=JiaoanAlbum.find(params[:jiaoan_album_id])
    @jiaoan = @jiaoan_album.jiaoans.new
    @jiaoan.author ||= realname
    @jiaoan.bh ||= "00-00-00"
  end

  # GET /jiaoans/1/edit
  def edit
  end

  # POST /jiaoans
  # POST /jiaoans.json
  def create
    @jiaoan_album=JiaoanAlbum.find(params[:jiaoan_album_id])
    respond_to do |format|
      if @jiaoan_album.jiaoans.create(jiaoan_params)
        format.html { redirect_to jiaoan_album_jiaoans_path(@jiaoan_album.id), notice: '教案创建成功' }
        format.json { render action: 'show', status: :created, location: @jiaoan }
      else
        format.html { render action: 'new' }
        format.json { render json: @jiaoan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jiaoans/1
  # PATCH/PUT /jiaoans/1.json
  def update
    respond_to do |format|
      if @jiaoan.update_attributes(jiaoan_params)
        format.html { redirect_to jiaoan_album_jiaoans_path(@jiaoan_album.id), notice: '教案更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @jiaoan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jiaoans/1
  # DELETE /jiaoans/1.json
  def destroy
    medias=@jiaoan.medias
    attachs=@jiaoan.attachs
    rm_grid_from_array(medias)
    rm_grid_from_array(attachs)
    if @jiaoan.delete
      respond_to do |format|
        format.html { redirect_to jiaoan_album_jiaoans_path, notice: "教案删除成功"}
        format.json { head :no_content }
      end
    else
      redirect_to jiaoan_album_jiaoans_path, flash: {error: "教案删除失败"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jiaoan
      @jiaoan_album=JiaoanAlbum.find(params[:jiaoan_album_id])
      @jiaoan = Jiaoan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jiaoan_params
      params[:jiaoan][:author] ||= realname
      params.require(:jiaoan).permit(:name, :bh, :content, :author,:medias).tap do |jiaoan|
        jiaoan[:jiaoan_album_id]=@jiaoan_album.id 
        unless params[:jiaoan][:attachs].blank?
          @attachs=[]
          attachs=params[:jiaoan][:attachs]
          attachs.each {|attach| @attachs<<uploadtogrid(attach)}
          @attachs = @jiaoan.attachs+@attachs if params[:action]=="update"
          jiaoan[:attachs]=@attachs
        end
        #medias handler
        @usertemps=Tempmedia.where(:login=>session['login']).first
        user_medias = @usertemps ? @usertemps.medias : []
        allmedias = params[:action]=="update" ? @jiaoan.medias+user_medias  : user_medias 
        content=params[:jiaoan][:content]
        used=medias_used(content,allmedias)                            
        @unused=allmedias-used
        jiaoan[:medias]=used
      end
    end
end
