class CrlogsController < ApplicationController
  before_action :basic_infos_required
  before_action :teacher_required
  before_action :root_required, only: [:edit,:update,:destroy]
  before_action :set_crlog, only: [:show, :edit, :update, :destroy]
  before_action :check_loger, only: [:edit,:update,:destroy]

  def check_loger
    if @crlog.loger!=realname
      redirect_to :back, flash: {error: "你不能操作别人的东西"}
    end
  end

  def remove_reply
    @crlog = Crlog.find(params[:id])
    reply=@crlog.crlog_replys.find(params[:reply_id])
    if @crlog.crlog_replys.delete(reply)
      redirect_to :back, flash: {notice: "回复删除成功"}
    else
      redirect_to :back, flash: {error: "回复删除失败"}
    end
  end

  def reply
    @crlog = Crlog.find(params[:crlog_id])
    @crlog_reply=@crlog.crlog_replys.create(reply: params[:reply],replyer: realname)
    if @crlog.save
      redirect_to :back , notice: "回复成功"
    else
      redirect_to :back , flash: {error: "回复成功"}
    end
  end

  def search
    hsh={}
    hsh[:croom] = params[:croom] unless params[:croom].blank?
    hsh[:banji] = params[:banji] unless params[:banji].blank?
    hsh[:course_name] = params[:course_name] unless params[:course_name].blank?
    hsh[:jiece] = params[:jiece] unless params[:jiece].blank?
    hsh[:use_date] = params[:use_date] unless params[:use_date].blank?
    hsh[:loger] = /#{params[:loger]}/ unless params[:loger].blank?
    @crlogs=Crlog.where(hsh).desc("created_at").page  params[:page]
    render :index
  end

  # GET /crlogs
  # GET /crlogs.json
  def index
    hsh={}
    hsh[:loger]=realname unless params[:loger].blank?
    params[:week] ||=current_week
    params[:week]=1 if params[:week].to_i<=0
    if current_semester
      sm_name=current_semester.full_name
    else
      sm_name=params[:semester] 
    end
    @semester=Semester.where(full_name: sm_name).first
    @begin_on,@end_on = week_range(@semester,params[:week])
    @crlogs = Crlog.where(hsh).gte(use_date: @begin_on).lte(use_date: @end_on)
  end

  # GET /crlogs/1
  # GET /crlogs/1.json
  def show
  end

  # GET /crlogs/new
  def new
    @crlog = Crlog.new
    @crlog.use_date ||= Time.now.strftime("%Y-%m-%d")
  end

  # GET /crlogs/1/edit
  def edit
  end

  # POST /crlogs
  # POST /crlogs.json
  def create
    @crlog = Crlog.new(crlog_params)

    respond_to do |format|
      if @crlog.save
        format.html { redirect_to crlogs_path(anchor: "/#{@crlog.croom}"), notice: '日志已经成功创建' }
        format.json { render action: 'show', status: :created, location: @crlog }
      else
        format.html { render action: 'new' }
        format.json { render json: @crlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crlogs/1
  # PATCH/PUT /crlogs/1.json
  def update
    respond_to do |format|
      if @crlog.update(crlog_params)
        format.html { redirect_to crlogs_path(anchor: "/#{@crlog.croom}"), notice: '日志已经成功更新' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @crlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crlogs/1
  # DELETE /crlogs/1.json
  def destroy
    @crlog.destroy
    respond_to do |format|
      format.html { redirect_to crlogs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crlog
      @crlog = Crlog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crlog_params
      params[:crlog][:loger]=realname
      params[:crlog][:semester]=current_semester.full_name
      params.require(:crlog).permit(:croom, :semester, :banji, :use_date, :course_name, :jiece, :computer_status, :garbage_status, :place_status, :status, :loger,  :desc)
    end
end
