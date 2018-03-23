# frozen_string_literal: true

require 'rails_helper'

describe 'タスク詳細画面', type: :feature do
  before do
    task = create(:task, title: 'Rspec test 1')
    visit task_path(task)
  end

  describe 'アクセス' do
    it '画面が表示されていること' do
      expect(page).to have_css('#show_task')
    end
  end

  describe 'タスクの登録内容の表示確認' do
    it 'タスク名が表示されていること' do
      expect(find('#task_title').value).to eq 'Rspec test 1'
    end

    it '内容が表示されていること' do
      expect(find('#task_description').value).to eq 'This is a sample description'
    end

    it '期日が表示されていること' do
      expect(find('#task_deadline').value).to eq '2018/03/01 00:00:00'
    end

    it 'ステータスが表示されていること' do
      expect(find('#task_status').value).to eq Task.human_attribute_name('statuses.progress')
    end

    it '優先度が表示されていること' do
      expect(find('#task_priority').value).to eq Task.human_attribute_name('priorities.high')
    end
  end

  describe '一覧画面への遷移', type: :feature do
    it '戻るボタンが表示されていること' do
      expect(find_link(I18n.t('helpers.submit.back')).visible?).to be_truthy
    end

    it '戻るボタンクリックで一覧画面に遷移すること' do
      click_on I18n.t('helpers.submit.back')
      expect(page).to have_css('#todo_app_task_list')
    end
  end
end
