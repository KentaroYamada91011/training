class Api::TasksController < ApplicationController
  before_action :set_task, only: [:destroy]
  def index
    @tasks = Task.all
    render json: @tasks
  end

  def create
    task = Task.new(task_param)
    if task.valid?
      task = task.save
      render json: {  status: 'SUCCESS', data: post }
    else
      render json: { status: 'ERROR', data: post.errors }
    end
  end

  def destroy
    @task.destroy
    render json: { status: 'SUCCESS', message: 'Delete the task', data: @task}
  end

  def update
    if @task.update(post_params)
      render json: @task
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
