# frozen_string_literal: true

# タスクコントローラー
class TasksController < ApplicationController
  attr_reader :task, :login_user

  before_action :check_login_user
  before_action :set_login_user, only: %i[index create]

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    @tasks = search_tasks(params)
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    @task = Task.find(params[:id])
  end

  # 作成画面
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # 編集画面
  # GET /tasks/[:タスクテーブルID]/edit
  def edit
    @task = Task.find(params[:id])
  end

  # ■画面更新系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = @login_user.id
    if @task.save
      flash[:notice] = I18n.t('flash.success.create',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to action: :new
    else
      render :new
    end
  end

  # タスクを更新する
  # POST /tasks/[:タスクテーブルID]
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.success.update',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to action: :edit
    else
      render :edit
    end
  end

  # タスクを削除する
  # POST /tasks/[:タスクテーブルID]
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = I18n.t('flash.success.delete',
                            name: I18n.t('tasks.header.name'),
                            value: @task.name)
    redirect_to tasks_url
  end

  private

  def task_params
    # TODO: ステップ20でラベル選択、複数登録可能とする
    params.require(:task).permit(:name,
                                 :details,
                                 :deadline,
                                 :status,
                                 :priority,
                                 label_ids: [])
  end

  def search_tasks(params)
    sort_key = create_sort_key(params[:sort])
    search_word = params[:search_word]
    search_btn = params[:search_btn]
    tasks = if search_btn == I18n.t('tasks.button.type.search')
              status = create_status
              find_tasks(@login_user.id, search_word, status, sort_key)
            else
              select_tasks(@login_user.id, sort_key)
            end
    tasks
  end

  def select_tasks(user_id, sort_key)
    tasks = Task.where(user_id: user_id)
                .includes(:task_label_relations, :labels)
                .order(sort_key)
                .page(params[:page])
    tasks
  end

  def find_tasks(user_id, search_word, status, sort_key)
    tasks = Task.where(user_id: user_id)
                .where(status: status)
                .where('name like ?', '%' + search_word + '%')
                .includes(:task_label_relations, :labels)
                .order(sort_key)
                .page(params[:page])
    tasks
  end

  def create_status
    status = if params[:status] == 'all' || params[:status].nil?
               Task.statuses.values
             else
               params[:status]
             end
    status
  end

  def create_sort_key(key)
    order    = ' DESC'
    sort_key = if key.nil?
                 'creation_date'
               else
                 key
               end
    sort_key + order
  end

  def set_login_user
    @login_user = current_user
  end

  def check_login_user
    redirect_to login_path unless logged_in?
  end
end
