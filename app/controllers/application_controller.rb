# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # httpsリダイレクト
  before_filter :ssl_redirect

  # ページング
  $per_page = 30

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

end
  