# -*- encoding : utf-8 -*-
class TokensController < ApplicationController
  before_action :root_required
  before_action :set_token, only: [:update, :destroy]

  before_action :check_auth, only: [:create]

  def check_auth
    if params[:auth] == '不通过'
      redirect_to redirect_uri+"?state="+params[:state]+"&error=deny"
    end
  end

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.where(user_id: user_id).page params[:page]
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params)
    @token.request_token = SecureRandom.hex
    @token.user_id = user_id

    respond_to do |format|
      if @token.save
        format.html { 
          redirect_to params[:redirect_uri]+"?code="+@token.request_token+"&state="+params[:state]
        }
        format.json { render action: 'show', status: :created, location: @token }
      else
        format.html { render action: 'new' }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  def update
    respond_to do |format|
      if @token.update(token_params)
        format.html { redirect_to @token, notice: 'Api key was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to tokens_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
      if @token.user_id!=user_id
        redirect_to :back, flash: {error: '你不能进行这个操作'}
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:app_id,:scopes)
    end
end
