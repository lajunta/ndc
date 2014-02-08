# -*- encoding : utf-8 -*-
class Api::UserController < ApplicationController
  def index
    unless params[:access_token].blank?
      @token=Token.where(access_token: params[:access_token]).first
    end
    if @token
      @user=User.find(@token.user_id)
      hsh={}
      hsh[:login]=@user.login
      hsh[:realname]=@user.realname
      if @user.logo
        hsh[:avatar_url]="http://localhost:3000/see/#{@user.logo['grid_id']}"
      end
      render json: hsh
    else
      render text: :error
    end
  end

  def avator
  end
end
