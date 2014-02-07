class SubmissionsController < ApplicationController
  before_action :teacher_required
  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  before_action :set_hub, only: [:new, :edit]
  before_action :check_attachs, only: [:create,:update]

  # GET /submissions
  # GET /submissions.json
  #
  def check_attachs
    if params[:attachs].blank?
      redirect_to :back ,flash: {error: "请选择一个文件"}
    end
  end

  def set_hub
    @hub = Hub.find(params[:hub_id])
  end

  def index
    @submissions = Submission.where(submmiter: realname)
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @hub=Hub.find(params[:hub_id])
    respond_to do |format|
      if @hub.submissions.create(submission_params)
        format.html { redirect_to hub_path(@hub.id), notice: '提交成功' }
        format.json { render action: 'show', status: :created, location: @submission }
      else
        format.html { render action: 'new' }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: '更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @hub=Hub.find(params[:hub_id])
    attachs=@submission.attachs
    rm_grid_from_array(attachs)
    if @submission.delete
      respond_to do |form|
        form.html { redirect_to hub_path(@hub), notice: "提交已经取消"}
        form.js {render :layout=>nil}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      @hub=Hub.find(params[:hub_id])
      params[:submission][:hub_id]=@hub.id
      params[:submission][:submitter]=realname
      params.require(:submission).permit(:submitter, :hub_id, :desc).tap do |sub|
        unless params[:attachs].blank?
          @attachs=[]
          attachs=params[:attachs]
          attachs.each {|attach| @attachs<<uploadtogrid(attach)}
          sub[:attachs]=@attachs
        end
      end
    end
end
