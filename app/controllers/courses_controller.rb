# -*- encoding : utf-8 -*-
class CoursesController < ApplicationController
  before_action :root_required
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :only=>["create","update"] do
    logo_check("course") 
  end

  def search
    @courses=Course.where(name: /#{params[:sstr]}/).page  params[:page]
    render :index
  end
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all.page params[:page]
  end

  def upload
    if request.post?
      require "spreadsheet"
      @file=params[:xls]
      unless @file
        flash[:error]="选择一个文件" 
        redirect_to :back and return
      end 
      book = Spreadsheet.open @file.tempfile
      sheet1 = book.worksheet 0
      right=wrong=updated=0
      existed=[]
      sheet1.each  do |row|
        old_course=Student.where(name: row[0]).first
        if old_course
          existed<<row[1]
          old_course.code=row[1]
          updated+=1 if old_student.save 
        else
          new_course=Course.new({name: row[0].to_s.strip,code: row[1].strip})
          new_course.save ? right+=1 : wrong+=1
        end 
      end 
      word="输入成功#{right},已经存在#{existed},更新#{updated}, 失败#{wrong}"
      flash[:notice]=word
      redirect_to courses_path and return
    end
  end
  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :code, :intro, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
