# -*- encoding : utf-8 -*-
require 'mongoid-grid_fs'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
#  before_action :miniprofiler
  before_action :pageit, only: [:type,:index,:search]
  before_action :set_data

  def miniprofiler
    Rack::MiniProfiler.authorize_request
  end

  def default_group
    session[:default_group]
  end

  def basic_infos_required
    if Semester.all.count==0
      if is_root?
        redirect_to semesters_path ,flash: {error: "请先设置学期信息"} and return
      else
        redirect_to root_path(trailing_slash: true) ,flash: {error: "基础信息不完整，请管理员设置"} and return
      end
    end
    if Group.where(type: "班级").all.count==0
      if is_root?
        redirect_to groups_path ,flash: {error: "请先添加一些班级"} and return
      else
        redirect_to root_path(trailing_slash: true) ,flash: {error: "基础信息不完整，请管理员设置"} and return
      end
    end
    if Course.all.count==0
      if is_root?
        redirect_to courses_path ,flash: {error: "请先设置课程信息"} and return
      else
        redirect_to root_path(trailing_slash: true) ,flash: {error: "基础信息不完整，请管理员设置"} and return
      end
    end
  end

  def set_data
    @semesters=Semester.all.map{|s| s.full_name}
    @banjis=Group.where(type: '班级').map{|g| g.name}
    @groups=Group.all.map{|g| g.name}
    @crooms=['C303','C304','C401','C402','C404','C503']
    @courses=Course.all.map{|c| c.name}
    @jieces=1..7

    if login?
      @user=User.find(user_id)
      if @user
      unless @user.config.blank?
        @fav_banjis=@user.config["fav_banjis"]
        @fav_crooms=@user.config["fav_crooms"]
        @fav_courses=@user.config["fav_courses"]
      end
      end
    end
  end

  def rm_grid_from_array(ary)
    unless ary.blank?
      ary.each do |a|
        grid.delete(a['grid_id'])
      end
    end
  end

  def medias_used(text,medias)
    return [] if medias.blank?
    grid_ids=medias.map{|media| media['grid_id']}
    used_grid_ids=[]
    grid_ids.each do |grid_id|
      used_grid_ids << grid_id if text.include?(grid_id.to_s)
    end
    medias.select{|media| used_grid_ids.include?(media['grid_id']) }
  end

  def current_week
    @semester=Semester.gte(ended_on: Date.today).lte(started_on: Date.today).first
    if @semester
      ((Date.today.end_of_week-@semester.started_on+1).to_i)/7
    else
      0
    end
  end
 
  def week_range(semester,num) 
    if semester
      begin_on = semester.started_on+((num.to_i-1)*7).days
      end_on = semester.ended_on+(num.to_i*7).days
      return begin_on,end_on
    end
  end

  def current_semester
    @semester=Semester.gte(ended_on: Date.today).lte(started_on: Date.today).first
    @semester or Semester.desc(:ended_on).first
  end

  def root_required
    unless is_root?
      redirect_to root_path(trailing_slash: true) , flash: {error: '身份不对'}
    end
  end

  def teacher_required
    unless is_teacher?
      redirect_to root_path(trailing_slash: true) , flash: {error:  '身份不对'}
    end
  end

  def is_teacher?
    session[:user_type]=='教师' or is_root?
  end

  def login_required
    unless login?
      redirect_to root_path(trailing_slash: true) , notice: '请先登录'
    end
  end

  def is_root?
    session[:login]=='root'
  end

  def pageit
    params[:page] ||= 1   
    per_page = 20 
    @num=per_page*(params[:page].to_i-1)
  end

  def sha2(str)
    Digest::SHA2.hexdigest(str)
  end

  def dbname
    'ndc'
  end

  def cu
    session[:login]
  end

  def realname
    session[:realname]
  end

  def user_id
    session[:user_id]
  end

  def login?
    !!session[:login]
  end

  def grid
    Mongoid::GridFs
    #@db = MongoClient.new.db(dbname)
    #Mongo::Grid.new(@db)
  end

  def uploadtogrid(upload)
    filename=upload.original_filename
    content_type=upload.content_type
    data = File.open(upload.tempfile.path)
    #saved = grid.put(data, :filename => filename, :content_type=>content_type)
    saved = grid.put(data,filename: SecureRandom.hex, metadata: {"filename"=>filename}, content_type: content_type)
    grid_data=grid.get(saved)
    length=grid_data.length
    file_size =
      case length
        when 0..1024**2
          (length.to_f/1024.to_f).round(1).to_s+"K"
        when 1024**2..1024*1024*15
          (length.to_f/(1024*1024).to_f).round(1).to_s+"M"
      end
    hsh = {:grid_id=>grid_data._id.to_s,:filename=>filename,
           :content_type=>content_type,:file_size=>file_size}
  end

  def logo_check(klass,w=100,h=100)
    if params[:logo]
      unless params[:logo].content_type.include?("image")
        flash[:error] = "请上传图片类型文件"
        redirect_to :back and return
      end
      Zbox::Qm.resize(params[:logo].tempfile.path,:width=>w,:height=>h)
      params[klass.to_sym][:logo]=uploadtogrid(params[:logo])      
    end
    if params[:action]=="update" and params[:logo]
      obj=eval("@#{klass}")
      unless obj.logo.blank?
        grid.delete(obj.logo['grid_id'])
      end
    end
  end

  helper_method :login?,:cu,:user_id,:realname,:is_root?, :is_teacher?,:current_week,:current_semester,:default_group
end
