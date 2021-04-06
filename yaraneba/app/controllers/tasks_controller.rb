# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :redirect_if_authorization_is_required
  before_action :redirect_if_user_not_allowed, except: %i[index new create]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Task.search(request, session[:id]).order("#{sort_column} #{sort_direction}")
    return if @tasks.blank?

    @tasks = @tasks.page(params[:page])
    render 'errors/not_found' if @tasks.out_of_range?
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = session[:id]

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: I18n.t('notice.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: I18n.t('notice.success') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: I18n.t('notice.success')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :detail, :status, :end_date)
  end

  def redirect_if_user_not_allowed
    redirect_to tasks_path, notice: I18n.t('notice.fault') if @task.user_id != session[:id]
  end
end
