class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    task = Task.new(task_params)
    task.save!
    redirect_to tasks_url, notice: "タスク「#{task.title}」を登録しました。"
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.title}」を更新しました。"
  end

  def destroy
    @task.destroy!
    redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
