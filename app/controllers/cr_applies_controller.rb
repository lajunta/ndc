class CrAppliesController < ApplicationController
  before_action :teacher_required
  before_action :set_cr_apply, only: [:change_status,:show, :edit, :update, :destroy]
  before_action :check_applyer, only: [:edit,:update,:destroy]
  before_action :root_required, only: [:export]

  def check_applyer
    unless @cr_apply.applyer!=realname or is_root?
      redirect_to :back, flash: {error: "你不能进行这个操作"}
    end
  end

  def export
    unless params[:status].blank?
      if params[:status]=="up"
        status=true
      elsif params[:status]=="down"
        status=false
      end
      @cr_applies = CrApply.where(status: status,semester: current_semester.full_name).all
    else
      @cr_applies = CrApply.where(semester: current_semester.full_name).all
    end
  end


  def change_status
    if request.xhr?
      if params[:status]=="up"
        status=true
      else
        status=false
      end
      @cr_apply.update_attribute(:status,status)
      respond_to do |form|
        form.js { render :layout=>false}
      end
    end
  end

  # GET /cr_applies
  # GET /cr_applies.json
  def index
    @cr_applies = CrApply.where(semester: current_semester.full_name).all
  end

  # GET /cr_applies/1
  # GET /cr_applies/1.json
  def show
  end

  # GET /cr_applies/new
  def new
    @cr_apply = CrApply.new
    @user=User.find(user_id)
    unless @user.config.blank?
      unless @user.config[:fav_courses].blank?
        @courses=@user.config[:fav_courses]
      end
    end
  end

  def edit
  end

  # POST /cr_applies
  # POST /cr_applies.json
  # params.require(:cr_apply).permit(:applyer, :semester, :croom, :course, :wday, :jiece)
  def create
    applys=params[:applys].compact.reject(&:empty?)
    unless applys.blank?
      applys.each do |apply|
        infos=apply.split("_")
        hsh={}
        hsh[:applyer]=realname
        hsh[:semester]=current_semester.full_name
        hsh[:croom]=infos[1]
        hsh[:course]=infos[0]
        hsh[:wday]=infos[2]
        hsh[:jiece]=infos[3]
        hsh[:status]=false
        cr_apply=CrApply.new(hsh)
        cr_apply.save
      end
      redirect_to cr_applies_path ,notice: "申请已经提交"
    else
      redirect_to :back ,flash: {error: "你没有任何选择"}
    end
  end

  # PATCH/PUT /cr_applies/1
  # PATCH/PUT /cr_applies/1.json
  def update
    respond_to do |format|
      if @cr_apply.update(cr_apply_params)
        format.html { redirect_to @cr_apply, notice: 'Cr apply was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cr_apply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cr_applies/1
  # DELETE /cr_applies/1.json
  def destroy
    @cr_apply.destroy
    respond_to do |format|
      format.html { redirect_to cr_applies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cr_apply
      @cr_apply = CrApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cr_apply_params
      params.require(:cr_apply).permit(:applyer, :semester, :croom, :course, :wday, :jiece)
    end
end
