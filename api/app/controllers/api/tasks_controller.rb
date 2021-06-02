class Api::TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :update]

  def index
    @tasks = Task.all.order(id: "DESC")
    render json: @tasks
  end

  def create
    task = Task.new(task_param)
    if task.valid?
      task = task.save
      render json: {  status: 'SUCCESS', data: task }
    else
      render json: { status: 'ERROR', data: task.errors }
    end
  end

  def destroy
    @task.destroy
    render json: { status: 'SUCCESS', message: 'Delete the task', data: @task}
  end

  def update
    if @task.update(task_params)
      render json: {  status: 'SUCCESS', data: @task }
    else
      render json: { status: 'ERROR', data: @task.errors }
    end
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
