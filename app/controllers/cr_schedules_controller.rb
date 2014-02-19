# -*- encoding : utf-8 -*-
class CrSchedulesController < ApplicationController
  before_action :root_required
  before_action :set_cr_schedule, only: [:show, :edit, :update, :destroy]

  # GET /cr_schedules
  # GET /cr_schedules.json
  def index
    @cr_schedules = CrSchedule.all.page params[:page]
  end

  # GET /cr_schedules/1
  # GET /cr_schedules/1.json
  def show
  end

  # GET /cr_schedules/new
  def new
    @cr_schedule = CrSchedule.new
    @cr_schedule.semester = current_semester.full
  end

  def get_latest
    @cr_applies = CrApply.where(status: true,semester: current_semester.full_name).all
    output=render_to_string(:template=>"cr_applies/export", :layout => false)
    @cr_schedule = CrSchedule.new(semester: current_semester.full_name,content: output)
    if @cr_schedule.save
      redirect_to root_path(trailing_slash: true),notice: "最新上机安排表设置成功"
    else
      redirect_to root_path(trailing_slash: true),flash: {error:  "最新上机安排表设置失败"}
    end
  end

  # GET /cr_schedules/1/edit
  def edit
  end

  # POST /cr_schedules
  # POST /cr_schedules.json
  def create
    @cr_schedule = CrSchedule.new(cr_schedule_params)

    respond_to do |format|
      if @cr_schedule.save
        format.html { redirect_to @cr_schedule, notice: '上机安排表创建成功.' }
        format.json { render action: 'show', status: :created, location: @cr_schedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @cr_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cr_schedules/1
  # PATCH/PUT /cr_schedules/1.json
  def update
    respond_to do |format|
      if @cr_schedule.update(cr_schedule_params)
        format.html { redirect_to @cr_schedule, notice: '上机安排表更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cr_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cr_schedules/1
  # DELETE /cr_schedules/1.json
  def destroy
    @cr_schedule.destroy
    respond_to do |format|
      format.html { redirect_to cr_schedules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cr_schedule
      @cr_schedule = CrSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cr_schedule_params
      params.require(:cr_schedule).permit(:semester, :name,:croom, :content, :used)
    end
end
