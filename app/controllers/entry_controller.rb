class EntryController < ApplicationController

  #-------#
  # input #
  #-------#
  def input
    if params[:commit] == "確認"
      @user = User.new( params[:user] )
      if @user.valid?
        render :action => "confirmation" and return
      end
    else
      @user = User.new( params[:user] )
    end
  end

  #--------------#
  # confirmation #
  #--------------#
  def confirmation
#    @user = User.new( params[:user] )
#    password_clear
  end

  #----------#
  # complete #
  #----------#
  def complete
    @user = User.new( params[:user] )

    if @user.save
      flash[:notice] = 'ユーザ登録が完了しました。<br /><br />'
      # ユーザ情報をセッションに格納
      user_session_set( @user )
      redirect_to :root and return
    else
      flash[:notice] = 'Error.'
#      password_clear
      render :action => "input" and return
    end
  end

  #-------#
  # login #
  #-------#
  def login
    @user = User.new( params[:login] )

    redirect_to :root if @user.blank?

    if !@user.login_id.blank? and !@user.password.blank?
      # ユーザ認証
      user = @user.authenticate

      unless user.blank?
        # ユーザ情報をセッションに格納
        user_session_set( user )

#        flash[:notice] = "ログインに成功しました。<br /><br />"
        redirect_to :root and return
      end
    end

    flash[:notice] = "無効なユーザ／パスワードです。<br /><br />"
    redirect_to :root and return
  end

  #--------#
  # logout #
  #--------#
  def logout
    session[:user_id] = nil

#    flash[:notice] = "ログアウトしました。"
    redirect_to :root and return
  end

  #------#
  # show #
  #------#
  def show
    @user = User.find_by_id( session[:user_id] )
  end

  #------#
  # edit #
  #------#
  def edit
    @user = User.find_by_id( session[:user_id] )
  end

  #--------#
  # update #
  #--------#
  def update
    @user = User.find_by_id( session[:user_id] )

    if params[:user].blank?
      flash[:notice] = "ユーザ情報がありません。<br /><br />"
      redirect_to :action => "edit" and return
    end

    # パスワードチェックがtrueで無ければ
    unless @user.password_check?( params[:user][:password] )
      flash[:notice] = "「現在のパスワード」が正しくありません。<br /><br />"
      redirect_to :action => "edit" and return
    end

    if !params[:user][:edit_password].blank? and !params[:user][:edit_password_confirmation].blank?
      # 変更するパスワードと再入力パスワードが一致しなければ
      unless params[:user][:edit_password] == params[:user][:edit_password_confirmation]
        flash[:notice] = "「変更するパスワード」と「変更するパスワード(再入力)」が一致しません。<br /><br />"
        redirect_to :action => "edit" and return
      else
        # パスワード更新
        params[:user][:password] = params[:user][:edit_password]
      end
    end

    # ユーザ情報を更新
    if @user.update_attributes( params[:user] )
      flash[:notice] = "ユーザ情報を更新しました。<br /><br />"
      redirect_to :action => "show" and return
    else
      flash[:notice] = "ユーザ情報の更新に失敗しました。<br /><br />"
      redirect_to :action => "edit" and return
    end
  end
  
  #---------------#
  # edit_password #
  #---------------#
  def edit_password
    @user = User.find( params[:id] )
  end
  
  #-----------------#
  # update_password #
  #-----------------#
  def update_password
    @user = User.find( params[:id] )
    params_user = params[:user]
    
    if params_user.blank?
      flash[:notice] = "ユーザ情報がありません。<br /><br />"
      redirect_to :action => "edit_password", :id => @user.id and return
    end

    # パスワードチェックがtrueで無ければ
    unless @user.password_check?( params_user[:password] )
      flash[:notice] = "「現在のパスワード」が正しくありません。<br /><br />"
      redirect_to :action => "edit_password", :id => @user.id and return
    end
    
    # 変更するパスワードと再入力パスワードが一致しなければ
    unless params_user[:edit_password] == params_user[:password_confirmation]
      flash[:notice] = "「変更するパスワード」と「変更するパスワード(再入力)」が一致しません。<br /><br />"
      redirect_to :action => "edit_password", :id => @user.id and return
    end

    # パスワード更新
    params_user[:password] = params_user[:edit_password]

    # ユーザ情報を更新
    if @user.update_attributes( params_user )
      flash[:notice] = "パスワードを変更しました。<br /><br />"
      redirect_to :action => "show", :id => @user.id and return
    else
      flash[:notice] = "パスワードの変更に失敗しました。<br /><br />"
      redirect_to :action => "edit_password", :id => @user.id and return
    end
  end

  private
  #------------------#
  # user_session_set #
  #------------------#
  def user_session_set( user )
    # ユーザ情報をセッションに格納
    session[:user_id] = user.id
    session[:login_id] = user.login_id
  end

end
