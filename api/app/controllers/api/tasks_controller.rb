class Api
  class TasksController < ApplicationController
    before_action :set_task, only: %i[destroy update]

    def index
      @tasks = Task.all
      render json: @tasks
    end

    def create
      task = Task.create!(task_param)
      render json: { status: 'SUCCESS', data: task }
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 'ERROR', message: e }
    end

    def destroy
      @task.destroy
      render json: { status: 'SUCCESS', message: 'Delete the task', data: @task }
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 'ERROR', message: e }
    end

    def update
      @task.update!(task_param)
      render json: { status: 'SUCCESS', data: @task }
    rescue ActiveRecord::RecordInvalid => e
      render json: { status: 'ERROR', message: e }
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_param
      params.fetch(:task, {}).permit(
        :user_id, :title, :description, :deadline, :status, :parent_id
      )
    end
  end
end
