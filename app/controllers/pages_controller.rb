class PagesController < ApplicationController
  before_action :teacher_required
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit,:update,:destroy]

  def check_owner
    if @page.author!=realname
      redirect_to :back, flash: {error: "你不能进行这个操作"}
    end
  end

  def name
    if params[:name].blank?
      redirect_to :back, flash: {error: "名字在哪里？"}
    else
      @page=Page.where(name: params[:name]).first
      if @page
        render :show ,layout: "nobody"
      else
        redirect_to :back, flash: {error: "没有这篇文章"}
      end
    end
  end

  def search
    @pages=Page.where(title: /#{params[:sstr]}/).page  params[:page]
    render :index
  end

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all.page params[:page]
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params[:page][:author]||=realname
      params.require(:page).permit(:title, :body, :author, :tags, :name)
    end
end
