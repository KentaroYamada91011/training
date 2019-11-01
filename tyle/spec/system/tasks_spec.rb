# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }

  describe 'views' do
    let!(:task) { Task.create(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0, due: '20201231') }
    before do
      Task.create!(name: 'task2', description: 'this is a task2', user_id: user.id, priority: 1, status: 1, due: '20210101')
      Task.create!(name: 'task3', description: 'this is a task3', user_id: user.id, priority: 2, status: 2, due: '20210102')
    end

    it 'tests /tasks/' do
      visit tasks_path
      expect(page).to have_content 'task1'
      expect(page).to have_content 'low'
      expect(page).to have_content 'waiting'
      expect(page).to have_content '2020/12/31'
      expect(page).to have_content 'task2'
      expect(page).to have_content 'medium'
      expect(page).to have_content 'in_progress'
      expect(page).to have_content '2021/01/01'
      expect(page).to have_content 'task3'
      expect(page).to have_content 'high'
      expect(page).to have_content 'done'
      expect(page).to have_content '2021/01/02'
    end

    it 'tests /tasks/new' do
      visit new_task_path
      fill_in 'task_name', with: 'task1'
      fill_in 'task_description', with: 'this is a task1'
      fill_in 'task_due', with: '20201231'
      select 'medium', from: 'task_priority'
      select 'in_progress', from: 'task_status'
      click_button '登録する'

      expect(page).to have_content 'タスクが追加されました！'
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is a task1'
      expect(page).to have_content 'medium'
      expect(page).to have_content 'in_progress'
      expect(page).to have_content '2020/12/31'
    end

    it 'tests /tasks/show' do
      visit task_path(task)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is a task1'
      expect(page).to have_content 'low'
      expect(page).to have_content 'waiting'
      expect(page).to have_content '2020/12/31'
    end

    it 'tests /tasks/edit' do
      visit edit_task_path(task)
      expect(page).to have_field 'task_name', with: 'task1'
      expect(page).to have_field 'task_description', with: 'this is a task1'
      expect(page).to have_field 'task_priority', with: 'low'
      expect(page).to have_field 'task_status', with: 'waiting'
      expect(page).to have_field 'task_due', with: '2020-12-31 00:00:00 +0900'
      fill_in 'task_name', with: 'task2'
      fill_in 'task_description', with: 'this is a task2'
      fill_in 'task_due', with: '20210101'
      select 'high', from: 'task_priority'
      select 'done', from: 'task_status'
      click_button '更新する'

      expect(page).to have_content 'タスクが更新されました！'
      expect(page).to have_content 'task2'
      expect(page).to have_content 'this is a task2'
      expect(page).to have_content 'high'
      expect(page).to have_content 'done'
      expect(page).to have_content '2021/01/01'
    end

    it 'tests a delete button at /tasks/show' do
      visit tasks_path
      expect(page).to have_content 'task1'
      expect(page).to have_content 'low'
      expect(page).to have_content 'waiting'
      expect(page).to have_content '2020/12/31'
      visit task_path(task)

      # click DELETE and Cancel
      click_on '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
      page.driver.browser.switch_to.alert.dismiss

      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is a task1'
      expect(page).to have_content 'low'
      expect(page).to have_content 'waiting'
      expect(page).to have_content '2020/12/31'

      # click DELETE and OK
      click_on '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content 'task1'
      expect(page).to have_no_content 'this is a task1'
      expect(page).to have_no_content 'low'
      expect(page).to have_no_content 'waiting'
      expect(page).to have_no_content '2020/12/31'
    end
  end

  describe 'ordering' do
    before do
      Task.create!(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0, due: '20201231', created_at: 2.days)
      Task.create!(name: 'task2', description: 'this is a task2', user_id: user.id, priority: 1, status: 1, due: '20201231', created_at: 1.day)
      Task.create!(name: 'task3', description: 'this is a task3', user_id: user.id, priority: 2, status: 2, due: '20201231', created_at: Time.zone.now)
    end

    context 'visit tasks_path' do
      subject { visit tasks_path }
      
      it 'tasks ordered by created_at with descending' do
        subject
        expect(page.all('.task-name').map(&:text)).to eq %w[task3 task2 task1]
      end
    end
  end
end
