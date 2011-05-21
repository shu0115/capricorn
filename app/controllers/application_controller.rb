# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

#  before_filter :authorize
  before_filter :ssl_redirect

  # ページング
  $per_page = 15

  # メモ最大数
  $memo_full = 100

  # ユーザ最大数
  $user_full = 100

  # ログインプロトコル
  if Rails.env.production?
    $login_protocol = "https"
  else
    $login_protocol = "http"
  end

  private
  #-----------#
  # authorize #
  #-----------#
  def authorize
    user = User.find_by_id( session[:user_id] )
    if user.blank?
      # セッション情報クリア
      user_session_clear
      session[:request_url] = request.url
      flash[:login_notice] = "ログインが必要です。<br /><br />"
      redirect_to :controller => "entry", :action => "login" and return
    end
  end

  #--------------#
  # ssl_redirect #
  #--------------#
  def ssl_redirect
    # httpへリダイレクト
    if Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s == "https" and params[:controller] == "public"
      request.env["HTTP_X_FORWARDED_PROTO"] = "http"
      redirect_to request.url and return
    elsif Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s != "https" and params[:controller] != "public"
      request.env["HTTP_X_FORWARDED_PROTO"] = "https"
      redirect_to request.url and return
    end
  end
  
  #------------------#
  # user_session_set #
  #------------------#
  def user_session_set( user )
    # ユーザ情報をセッションに格納
    session[:user_id] = user.id
    session[:login_id] = user.login_id
    session[:display_name] = User.get_display_name( user.id )
  end

  #--------------------#
  # user_session_clear #
  #--------------------#
  def user_session_clear
    # ユーザ情報セッションクリア
    session[:user_id] = nil
    session[:login_id] = nil
    session[:display_name] = nil
  end

end
  