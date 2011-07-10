class TasksController < ApplicationController

  #-------#
  # index #
  #-------#
  def index
    @tasks, @search = Task.search( :user_id => session[:user_id], :params => params, :search => params[:search] )
    @task_categorys = Task.categorys( session[:user_id] )
  end

  #------#
  # list #
  #------#
  def list
    @tasks, @search = Task.search( :user_id => session[:user_id], :params => params, :search => params[:search] )
    render :partial => 'list'
  end

  #------#
  # show #
  #------#
  def show
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )
  end

  #-----#
  # new #
  #-----#
  def new
    @task = Task.new
  end

  #------#
  # edit #
  #------#
  def edit
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )
  end

  #--------#
  # create #
  #--------#
  def create
    @task = Task.new( params[:task] )
    @task.user_id = session[:user_id]

    unless @task.save
      flash[:remote_notice] = 'タスクの作成に失敗しました。'
      redirect_to :action => "index" and return
    end
    
#    redirect_to :action => "index", :search => @search, :category => params[:search][:category], :page => 1 and return
    redirect_to :action => "index", :search => @search, :category => params[:task][:category], :page => 1, :task_status => params[:task_status] and return
  end

  #--------#
  # update #
  #--------#
  def update
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )

    if @task.update_attributes( params[:task] )
      redirect_to :action => "index", :id => @task.id, :search => params[:search], :category => params[:search][:category], :page => params[:page], :task_status => params[:task_status] and return
    else
      flash[:remote_notice] = 'タスクの更新に失敗しました。'
      render :action => "edit" and return
    end
  end

  #---------------#
  # remote_update #
  #---------------#
  def remote_update
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )

    unless @task.update_attributes( params[:task] )
      flash[:remote_notice] = 'タスクの更新に失敗しました。'
    end

    @tasks, @search = Task.search( :user_id => session[:user_id], :params => params, :search => params[:search] )
    render :partial => 'list'
  end

  #-------------#
  # remote_done #
  #-------------#
  def remote_done
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )

    task = Hash.new
    task[:status] = params[:set_status]
    task[:complete_date] = Time.now if params[:set_status] == "完了"
    task[:complete_date] = nil if params[:set_status] == ""

    unless @task.update_attributes( task )
      flash[:remote_notice] = 'タスクの更新に失敗しました。'
    end

    @tasks, @search = Task.search( :user_id => session[:user_id], :params => params, :search => params[:search] )
    render :partial => 'list'
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @task = Task.find_by_id_and_user_id( params[:id], session[:user_id] )

    unless @task.destroy
      flash[:remote_notice] = '削除に失敗しました。'
    end

    redirect_to :action => "index", :search => params[:search], :category => params[:category], :task_status => params[:task_status]
  end
end
