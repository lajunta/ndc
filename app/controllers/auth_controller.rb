class AuthController < ApplicationController
  def auth 
    psd=params[:password]
    login=params[:login]
    @user=User.where(password: psd,login: login).first
    if @user
      session[:login]=@user.login
      session[:user_id]=@user.id
      redirect_to root_path ,notice: "登录成功"
    else
      redirect_to :back ,alert: "用户名密码不对"
    end
  end

  def login
  end

  def logout
    session[:login]=nil
    session[:user_id]=nil
    redirect_to root_path ,notice: "你已经登出"
  end

  def authorize
    if params[:redirect_uri] and params[:app_id] and params[:state]
      @app=App.where(redirect_uri: params[:redirect_uri], app_id: params[:app_id]).first
      render text: "提供的信息有误" unless @app
      session[:code]=SecureRandom.hex
    else
      render text: "请提供AppId和回调地址和状态符"
    end
  end

  def authorizeit
    @user=User.where(login: params[:login],password: params[:password]).first
    if @user
      @app=App.where(redirect_uri: params[:redirect_uri], app_id: params[:app_id]).first
      session[:code]=SecureRandom.hex
      session[:login]=@user.login
      session[:user_id]=@user.id
      render :authorize
    else
      redirect_to authorize_path , notice: "用户名密码错误"
    end
  end

  def access_token
    if params[:app_id] and params[:app_secret] and params[:code] and params[:redirect_uri]
      if session[:code] == params[:code]
        @app=App.where(app_id: params[:app_id],app_secret: params[:app_secret]).first
        ak=ApiKey.first(:user_id => session["user_id"])
        if ak.blank?
          ak=ApiKey.create({"app_id"=>@app.app_id,"user_id" => session["user_id"]})
        end
        redirect_to params[:redirect_uri]+"?access_token="+ak.access_token
      else
        redirect_to params[:redirect_uri] ,notice: '请求码错误'
      end
    else
      render text: '参数不完整'
    end
  end

end
