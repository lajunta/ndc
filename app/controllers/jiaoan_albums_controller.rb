class JiaoanAlbumsController < ApplicationController
  before_action :teacher_required
  before_action :set_jiaoan_album, only: [:show, :edit, :update, :print, :destroy]
  before_action :check_creator, only: [:edit, :update, :destroy]
  before_action :check_cooperators, only: [:print]
  before_action :only=>["create","update"] do
    logo_check("jiaoan_album") 
  end


  def check_cooperators
    unless @jiaoan_album.cooperators.include?(realname) or @jiaoan_album.creator==realname
      redirect_to :back, flash: {error: "你不能进行操作"}
    end
  end

  def check_creator
    unless is_root? or @jiaoan_album.creator==realname
      redirect_to :back, flash: {error: "你不能进行操作"}
    end
  end

  # GET /jiaoan_albums
  # GET /jiaoan_albums.json
  def index
    @jiaoan_albums = JiaoanAlbum.all.page params[:page]
  end

  # GET /jiaoan_albums/1
  # GET /jiaoan_albums/1.json
  def show
  end

  # GET /jiaoan_albums/new
  def new
    @jiaoan_album = JiaoanAlbum.new
  end

  def print
    @jiaoans = @jiaoan_album.jiaoans
    render layout: 'print'
  end

  # GET /jiaoan_albums/1/edit
  def edit
  end

  # POST /jiaoan_albums
  # POST /jiaoan_albums.json
  def create
    @jiaoan_album = JiaoanAlbum.new(jiaoan_album_params)

    respond_to do |format|
      if @jiaoan_album.save
        format.html { redirect_to jiaoan_albums_path, notice: '教案集创建成功' }
        format.json { render action: 'show', status: :created, location: @jiaoan_album }
      else
        format.html { render action: 'new' }
        format.json { render json: @jiaoan_album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jiaoan_albums/1
  # PATCH/PUT /jiaoan_albums/1.json
  def update
    respond_to do |format|
      if @jiaoan_album.update(jiaoan_album_params)
        format.html { redirect_to jiaoan_albums_path, notice: '教案集更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @jiaoan_album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jiaoan_albums/1
  # DELETE /jiaoan_albums/1.json
  def destroy
    @jiaoan_album.destroy
    grid.delete(@jiaoan_album.logo["grid_id"])
    respond_to do |format|
      format.html { redirect_to jiaoan_albums_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jiaoan_album
      @jiaoan_album = JiaoanAlbum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jiaoan_album_params
      params.require(:jiaoan_album).permit(:name, :creator, :cooperators, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
