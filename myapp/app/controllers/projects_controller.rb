class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]

  def show
    @show_task_id = params[:show_task_id]
  end

  def index
    @projects = current_user.projects.page(params[:page])
  end

  def create
    project = Project.new(request_params)
    if project.valid?
      project.users << current_user
      project.create!
      redirect_to project_url(project.id), alert: I18n.t('flash.success_create', model_name: 'project')
    else
      redirect_to projects_url, alert: I18n.t('flash.failed_create', model_name: 'project')
    end
  end

  def update
    @project.update(request_params)
    if @project.valid?
      @project.save
      render status: 200, json: {}
    else
      render status: 400, json: {}
    end
  end

  def destroy
    project_name = @project.name
    @project.destroy
    redirect_to projects_url, alert: I18n.t('flash.success_destroy', model_name: 'project')
  end

  private

  def find_project
    @project ||= current_user.projects.find_by!(id: params[:id])
  end

  def request_params
    params.require(:project).permit(:name)
  end
end