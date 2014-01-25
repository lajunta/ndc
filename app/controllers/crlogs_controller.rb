class CrlogsController < ApplicationController
  before_action :teacher_required
  before_action :set_crlog, only: [:show, :edit, :update, :destroy]
  before_action :set_data, only: [:new, :edit]

  # GET /crlogs
  # GET /crlogs.json
  def index
    @crlogs = Crlog.all
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
        format.html { redirect_to @crlog, notice: 'Crlog was successfully created.' }
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
        format.html { redirect_to @crlog, notice: 'Crlog was successfully updated.' }
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
      params.require(:crlog).permit(:croom, :banji, :use_date, :course_name, :jiece, :computer_status, :garbage_status, :place_status, :status, :logger, :closed_by, :desc)
    end
end
