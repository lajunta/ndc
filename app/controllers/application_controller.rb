require 'mongoid-grid_fs'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :pageit, only: [:type,:index,:search]
  before_action :set_data

  def set_data
    @semesters=Semester.all.map{|s| s.full_name}
    @banjis=Group.where(type: '班级').map{|g| g.name}
    @crooms=['C301','C302','C304','C401','C402','C403','C404']
    @courses=Course.all.map{|c| c.name}
    @jieces=['1-2','3-4','5-6']
  end

  def root_required
    unless is_root?
      redirect_to root_path , flash: {error: '身份不对'}
    end
  end

  def teacher_required
    unless is_teacher?
      redirect_to root_path , flash: {error:  '身份不对'}
    end
  end

  def is_teacher?
    session[:user_type]=='教师'
  end

  def login_required
    unless login?
      redirect_to root_path , notice: '请先登录'
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
    #id = grid.put(data, :filename => filename, :content_type=>content_type)
    saved = grid.put(data)
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

  helper_method :login?,:cu,:user_id,:realname,:is_root?, :is_teacher?
end
