class AuthController < ApplicationController
  layout "nobody"
  skip_before_filter :verify_authenticity_token, :only=>[:access_token]
  def auth 
    psd=sha2(params[:password])
    login=params[:login]
    @user=User.where(password: psd,login: login).first
    if @user
      session[:login]=@user.login
      session[:realname]=@user.realname
      session[:default_group]=@user.default_group
      session[:user_type]=@user.type
      session[:user_id]=@user.id.to_s
      redirect_to root_path ,notice: "登录成功"
    else
      redirect_to :back ,alert: "用户名密码不对"
    end
  end

  def login
  end

  def logout
    session[:login]=nil
    session[:realname]=nil
    session[:user_type]=nil
    session[:user_id]=nil
    session[:default_group]=nil
    redirect_to root_path ,notice: "你已经登出"
  end

  def authorize
    if params[:redirect_uri] and params[:app_id] and params[:state]
      @app=App.where(redirect_uri: params[:redirect_uri], app_id: params[:app_id]).first
      render text: "提供的信息有误" and return unless @app 
    else
      render text: "请提供AppId和回调地址和状态符" and return
    end
    if login?
      check_token 
    end
  end


  def check_token
      @token=Token.where(user_id: user_id,app_id: params[:app_id]).first
      if @token
        code = SecureRandom.hex
        @token.request_token = code
        @token.save
        redirect_to params[:redirect_uri]+"?code="+code+"&state="+params[:state]
      else
        render :authorizeit and return
      end
  end

  def authorizeit
    @user=User.where(login: params[:login],password: sha2(params[:password])).first
    if @user 
      @app=App.where(redirect_uri: params[:redirect_uri], app_id: params[:app_id]).first
      session[:login]=@user.login
      session[:user_id]=@user.id
      session[:realname]=@user.realname
      check_token and return
    else
      redirect_to authorize_path , notice: "用户名密码错误"
    end
  end

  def access_token
    if params[:app_id] and params[:app_secret] and params[:code] and params[:redirect_uri]
      @app=App.where(app_id: params[:app_id],app_secret: params[:app_secret]).first
      if @app
        @token=Token.where(request_token: params[:code],app_id: params[:app_id]).first
        if @token.access_token.blank? or (@token.access_token and @token.expires_at > Time.now)
          @token.access_token = SecureRandom.hex
          @token.request_token = nil
          @token.expires_at = Time.now + 1.hour
          @token.save
        end
        render json: {access_token: @token.access_token} and return
      else
        render json: {error: '客户端验证错误'} and return
      end
    else
      render json: {error: '参数不完整'} and return
    end
  end

end
