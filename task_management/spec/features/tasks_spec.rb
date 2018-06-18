require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    Capybara.default_host = 'http://localhost:3000'
    @task = create(:task)
  end

  scenario '一覧画面からタスク登録画面に遷移' do
    visit root_path
    click_button 'new'
    expect(current_url).to eq 'http://localhost:3000/tasks/new'
    expect(page).to have_field 'task_task_name'
    expect(page).to have_field 'task_description'
    expect(page).to have_button 'Create Task'
  end
  
  scenario 'タスクの登録' do
    visit 'http://localhost:3000/tasks/new'
    fill_in 'task_task_name', with: "#{@task.task_name}"
    fill_in 'task_description', with: "#{@task.description}"
    click_button 'Create Task'

    expect(current_url).to eq 'http://localhost:3000/'
    expect(page).to have_content 'タスクを登録しました'
    expect(page).to have_content "タスク：#{@task.task_name}"
  end

  scenario '一覧画面からタスク詳細画面への遷移' do
    visit root_path
    click_on "タスク：#{@task.task_name}"
    
    expect(current_url).to eq "http://localhost:3000/tasks/show/#{@task.id}"
    expect(page.all('タスクを更新しました').empty?).to eq true
    expect(page).to have_button 'home'
    expect(page).to have_button 'edit'
    expect(page).to have_button 'delete'
    expect(page).to have_content "タスク：#{@task.task_name}"
    expect(page).to have_content "詳細　：#{@task.description}"
  end

  scenario 'タスク詳細画面から一覧画面に遷移' do
    visit "http://localhost:3000/tasks/show/#{@task.id}"
    click_button 'home'

    expect(current_url).to eq 'http://localhost:3000/'
    expect(page.all('タスクを登録しました').empty?).to eq true
    # delete_message = 'タスク：task_name4を削除しました'
    expect(page.all('タスク：task_name4を削除しました').empty?).to eq true　# nokogiriエラー
    expect(page).to have_button 'new'
    expect(page).to have_content "タスク：#{@task.task_name}"
  end

  scenario 'タスク詳細画面からタスク編集画面に遷移' do
    visit "http://localhost:3000/tasks/show/#{@task.id}"
    click_button 'edit'
    
    expect(current_url).to eq "http://localhost:3000/tasks/edit/#{@task.id}" 
    expect(page).to have_field 'task_task_name', with: @task.task_name
    expect(page).to have_field 'task_description', with: @task.description
    expect(page).to have_button 'Update Task'
  end

  scenario 'タスクの編集' do
    visit "http://localhost:3000/tasks/edit/#{@task.id}"
    fill_in 'task_task_name', with: "#{@task.task_name}(edited)"
    fill_in 'task_description', with: "#{@task.description}(edited)"
    click_button 'Update Task'

    expect(current_url).to eq "http://localhost:3000/tasks/show/#{@task.id}"
    expect(page).to have_content 'タスクを更新しました'
    expect(page).to have_content "タスク：#{@task.task_name}(edited)"
    expect(page).to have_content "詳細　：#{@task.description}(edited)"
  end

  scenario 'タスクの削除' do
    visit "http://localhost:3000/tasks/show/#{@task.id}"
    click_button 'delete'
    visit current_path
    
    expect(current_url).to eq 'http://localhost:3000/'
    expect(page).to have_content "タスク：#{@task.task_name}を削除しました"
    expect(page.all("タスク：#{@task.task_name}").empty?).to eq true
  end
end
