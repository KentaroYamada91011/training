class Api::TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :update]

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def create
    task = Task.create!(task_param)
    render json: {  status: 'SUCCESS', data: task }
    rescue => e
      render json: { status: 'ERROR', message: e }
  end

  def destroy
    @task.destroy
    render json: { status: 'SUCCESS', message: 'Delete the task', data: @task}
    rescue => e
      render json: { status: 'ERROR', message: e }
  end

  def update
    @task.update!(task_param)
    rescue => e
      render json: { status: 'ERROR', message: e }
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_param
    data = params.fetch(:task, {}).permit(
      :user_id, :title, :description, :deadline, :status, :parent_id
    )
    data
  end
end
