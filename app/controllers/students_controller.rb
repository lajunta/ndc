# -*- encoding : utf-8 -*-
class StudentsController < ApplicationController
  before_action :root_required
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  before_action :only=>["create","update"] do
    logo_check("student") 
  end

  before_action :check_student, only: [:edit,:update,:destroy]

  def check_student
    if @student.realname!=realname
      redirect_to :back, flash: {error: "你不能操作别人的东西"}
    end
  end

  def search
    @students=Student.where(realname: /#{params[:sstr]}/).page  params[:page]
    render :index
  end

  def upload
    if request.post?
      require "spreadsheet"
      @file=params[:stxls]
      unless @file
        flash[:error]="选择一个文件" 
        redirect_to :back and return
      end 
      book = Spreadsheet.open @file.tempfile
      sheet1 = book.worksheet 0
      right=wrong=updated=0
      existed=[]
      sheet1.each 1 do |row|
        old_student=Student.where(default_group: row[0], realname: row[1]).first
        if old_student
          existed<<row[1]
          old_student.default_group=row[0]
          old_student.realname=row[1]
          if old_student.save 
            updated+=1
          end
        else
          #randpsd=Random.new.rand(1000..9999)
          new_student=Student.new({default_group: row[0].to_s.strip,realname: row[1].strip})
          new_student.save ? right+=1 : wrong+=1
        end 
      end 
      word="输入成功#{right},已经存在#{existed},更新#{updated}, 失败#{wrong}"
      flash[:notice]=word
      redirect_to students_path and return
    end 
  end

  # GET /students
  # GET /students.json
  def index
    @students = Student.all.page params[:page]
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student }
      else
        format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:realname, :sex, :birthday, :default_group, :other_groups, :address, :hometel, :mobile, :father_name, :mother_name, :father_workplace, :mother_workplace, :father_profession, :mother_profession, :father_tel, :mother_tel, :intro, :logo => [:grid_id,:filename,:content_type,:file_size])
    end
end
