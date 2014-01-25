class SeatsController < ApplicationController
  before_action :set_seat, only: [:show, :edit, :update, :destroy]

  before_action :set_data, only: [:new, :edit]

  before_action :only=>["create","update"] do
    unless params[:seat_xls].blank?
      @file=params[:seat_xls]
      require "spreadsheet"
      book = Spreadsheet.open @file.tempfile
      sheet1 = book.worksheet 0
      hsh={}
      sheet1.each 1 do |row|
        hsh[row[0].to_i]=row[1]
      end
      params[:seat][:arrangement]=Marshal.dump(hsh)     
    end
  end

  def set_data
    @semesters=Semester.all.map{|s| s.full_name}
    @banjis=Group.where(type: '班级').map{|g| g.name}
    @crooms=['C301','C302','C304','C401','C402','C403','C404']
    @courses=Course.all.map{|c| c.name}
  end

  # GET /seats
  # GET /seats.json
  def index
    @seats = Seat.all.page params[:page]
  end

  # GET /seats/1
  # GET /seats/1.json
  def show
  end

  # GET /seats/new
  def new
    @seat = Seat.new
    @seat.tname ||= realname
  end

  # GET /seats/1/edit
  def edit
  end

  # POST /seats
  # POST /seats.json
  def create
    @seat = Seat.new(seat_params)

    respond_to do |format|
      if @seat.save
        format.html { redirect_to @seat, notice: 'Seat was successfully created.' }
        format.json { render action: 'show', status: :created, location: @seat }
      else
        format.html { render action: 'new' }
        format.json { render json: @seat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seats/1
  # PATCH/PUT /seats/1.json
  def update
    respond_to do |format|
      if @seat.update(seat_params)
        format.html { redirect_to @seat, notice: 'Seat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seats/1
  # DELETE /seats/1.json
  def destroy
    @seat.destroy
    respond_to do |format|
      format.html { redirect_to seats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seat
      @seat = Seat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seat_params
      params.require(:seat).permit(:semester, :tname, :banji, :croom, :course_name, :arrangement)
    end
end