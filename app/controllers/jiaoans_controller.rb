class JiaoansController < ApplicationController
  before_action :teacher_required
  before_action :set_jiaoan, only: [:show, :edit, :update, :destroy]

  before_action :set_jiaoan_albums ,only: [:new,:edit]
  before_action :attachs_handler, only: [:create, :update]


  def attachs_handler
    @arry=[]
    unless params[:jiaoan][:attachs].blank?
      attachs=params[:jiaoan][:attachs]
      attachs.each do |attach|
        @arry<<uploadtogrid(attach)
      end
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
    @jiaoan_album.jiaoans.delete(@jiaoan)
    respond_to do |format|
      format.html { redirect_to jiaoan_album_jiaoans_path, notice: "教案删除成功"}
      format.json { head :no_content }
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
      params.require(:jiaoan).permit(:name, :bh, :content, :author).tap do |jiaoan|
        jiaoan[:attachs]=@arry
        jiaoan[:medias]=[]
      end
    end
end
