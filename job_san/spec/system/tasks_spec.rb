# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, :require_login, js: true, type: :system do
  before { travel_to(Time.zone.local(2020, 12, 24, 21, 0o0, 0o0)) }
  let(:sample_task_name) { 'やらなきゃいけないサンプル' }
  let(:sample_task_description) { 'やらなきゃいけないサンプル説明文' }
  let(:sample_task_status) { 'todo' }
  let(:now) { Time.current }
  let(:today) { Time.zone.today }
  let!(:sample_task) {
    create(:task,
           name: sample_task_name,
           description: sample_task_description,
           created_at: now,
           target_date: today,
           status: sample_task_status,
           user: login_user)
  }

  describe '#index' do
    let!(:sample_task_2) { create(:task, created_at: now + 2.days, target_date: today - 1.day, user: login_user) }
    let!(:sample_task_3) { create(:task, created_at: now + 1.day, target_date: today + 1.day, user: login_user) }
    let!(:other_user_task) { create(:task) }
    let!(:sample_labels) { create_list(:label, 3) }
    let(:sort_ids_by_created_at) { sort_task_ids(:created_at) }
    let(:sort_ids_by_target_date) { sort_task_ids(:target_date) }
    before { visit tasks_path }
    def sort_task_ids(key)
      [sample_task, sample_task_2, sample_task_3]
        .sort_by(&key).reverse
        .map { |t| t.id.to_s }
    end

    def fetch_viewed_task_ids
      page.all('tbody td:first-child').map(&:text)
    end

    it 'tasks are sorted by created_at desc' do
      expect(fetch_viewed_task_ids).to eq(sort_ids_by_created_at)
    end

    context 'when tasks exist over 10' do
      before do
        create_list(:task, 10, user: login_user)
        visit tasks_path
      end
      let(:first_page_tasks) { Task.where(user: login_user).order(created_at: :desc).limit(10).offset(0) }
      let(:next_page_tasks) { Task.where(user: login_user).order(created_at: :desc).limit(10).offset(10) }

      it 'should show paginated tasks' do
        expect(fetch_viewed_task_ids).to match_array(first_page_tasks.map { |t| t.id.to_s })
        click_on '次へ ›'
        sleep(0.3)
        expect(fetch_viewed_task_ids).to match_array(next_page_tasks.map { |t| t.id.to_s })
      end
    end

    context 'when click 完了日' do
      before do
        click_on '完了日'
        # 表示が完了する前にクローリングが走ってしまうので、待機する
        sleep(0.3)
      end

      it 'tasks are sorted by target_date desc' do
        expect(fetch_viewed_task_ids).to eq(sort_ids_by_target_date)
      end
    end

    context 'when click 作成日 twice' do
      before do
        (0..1).each do |_|
          click_on '作成日'
          # 表示が完了する前にクローリングが走ってしまうので、待機する
          sleep(0.3)
        end
      end

      it 'tasks are sorted by created_at asc' do
        expect(fetch_viewed_task_ids).to eq(sort_ids_by_created_at.reverse)
      end
    end

    context 'when search tasks with a task_name' do
      let(:search_task_name) { SecureRandom.uuid }
      let!(:filtered_tasks) { create_list(:task, 3, name: search_task_name, user: login_user) }
      before do
        fill_in 'タスク名 は以下を含む', with: search_task_name[2..7]
        click_button '検索'
        sleep(0.3)
      end

      it 'tasks are filtered by partial matched name' do
        expect(fetch_viewed_task_ids).to match_array(filtered_tasks.map { |t| t.id.to_s })
      end
    end

    context 'when search tasks with a label' do
      before do
        sample_task.labels << sample_labels
        check(sample_labels.first.name)
        click_button '検索'
        sleep(0.3)
      end

      it 'tasks are filtered by a matched label' do
        expect(fetch_viewed_task_ids).to match_array(sample_task.id.to_s)
      end
    end

    context 'when user does not login yet' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        visit tasks_path
      end

      it 'render login page' do
        expect(current_path).to eq login_path
      end
    end
  end

  describe '#show' do
    it 'visit show page' do
      visit task_path id: sample_task.id
      expect(page).to have_content sample_task_name
    end

    context 'when user does not login yet' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        visit task_path id: sample_task.id
      end

      it 'render login page' do
        expect(current_path).to eq login_path
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }

    context 'submit valid values' do
      let(:create_task_name) { 'これから作るタスクの名前' }
      let(:create_task_description) { 'これから作るタスクの説明文' }
      let(:create_task_target_date) { today + 3.days }

      before do
        create(:label)
        fill_in 'タスク名', with: create_task_name
        fill_in '説明文', with: create_task_description
        [create_task_target_date.year,
         create_task_target_date.month,
         create_task_target_date.day].each_with_index.each do |v, i|
          find("#task_target_date_#{i + 1}i").find("option[value='#{v}']").select_option
        end
      end

      subject { click_button '作成' }

      it 'move to task list page' do
        subject
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクを作成したよ'
      end

      it 'create new task' do
        expect { subject }.to change(Task.where(user: login_user), :count).by(1)
        created_task = Task.where(user: login_user).last
        expect(created_task.name).to eq(create_task_name)
        expect(created_task.description).to eq(create_task_description)
        expect(created_task.target_date).to eq(create_task_target_date)
      end
    end

    context 'when user does not login yet' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        visit new_task_path
      end

      it 'render login page' do
        expect(current_path).to eq login_path
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path id: sample_task.id }

    context 'submit valid values' do
      let(:update_task_name) { '更新するタスクの名前' }
      let(:update_task_description) { '更新するタスクの説明文' }
      let(:update_task_target_date) { today + 3.days }
      let(:update_task_status) { 'doing' }
      let(:updated_task) { Task.find(sample_task.id) }
      before do
        fill_in 'タスク名', with: update_task_name
        fill_in '説明文', with: update_task_description
        find('#task_status').find("option[value='#{update_task_status}']").select_option
        [update_task_target_date.year,
         update_task_target_date.month,
         update_task_target_date.day].each_with_index.each do |v, i|
          find("#task_target_date_#{i + 1}i").find("option[value='#{v}']").select_option
        end
      end

      subject { click_button '更新' }

      it 'move to task updated task page' do
        expect { subject }.to change {
          current_path
        }.from(edit_task_path(id: sample_task.id))
         .to(task_path(id: sample_task.id))
        expect(page).to have_content 'タスクを更新したよ'
      end

      it 'update selected task' do
        expect { subject }.to change {
          updated_task.reload
          updated_task.name
        }.from(sample_task_name).to(update_task_name)
          .and change {
            updated_task.description
          }.from(sample_task_description).to(update_task_description)
          .and change {
            updated_task.target_date
          }.from(today).to(update_task_target_date)
          .and change {
            updated_task.status
          }.from(sample_task_status).to(update_task_status)
      end
    end

    context 'when user does not login yet' do
      let(:update_task_name) { '更新するタスクの名前' }
      let(:update_task_description) { '更新するタスクの説明文' }
      let(:update_task_target_date) { today + 3.days }
      let(:update_task_status) { 'doing' }
      let(:updated_task) { Task.find(sample_task.id) }
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        fill_in 'タスク名', with: update_task_name
        fill_in '説明文', with: update_task_description
        find('#task_status').find("option[value='#{update_task_status}']").select_option
        [update_task_target_date.year,
         update_task_target_date.month,
         update_task_target_date.day].each_with_index.each do |v, i|
          find("#task_target_date_#{i + 1}i").find("option[value='#{v}']").select_option
        end
      end

      it 'render login page' do
        visit edit_task_path id: sample_task.id
        expect(current_path).to eq login_path
      end

      it 'should not update selected task' do
        expect {
          subject
          updated_task.reload
        }.not_to change {
          [updated_task.name,
           updated_task.description,
           updated_task.target_date,
           updated_task.status]
        }
      end
    end
  end

  describe '#destroy' do
    before { visit task_path(id: sample_task.id) }

    subject do
      page.accept_confirm do
        click_on '削除'
      end
      # 削除処理が完了する前にテストコードが進んでしまうので、待機する。
      sleep 0.1
    end

    it 'move to task list page' do
      expect { subject }.to change { current_path }.from(task_path(id: sample_task.id)).to(tasks_path)
      expect(page).to have_content 'タスクを削除したよ'
    end

    it 'delete selected task' do
      expect { subject }.to change { Task.count }.by(-1)
    end

    context 'when user does not login yet' do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil) }

      it 'render login page' do
        visit task_path(id: sample_task.id)
        expect(current_path).to eq login_path
      end

      it 'should not delete selected task' do
        expect { subject }.to change {
          Task.count
        }.by(0).and change {
          current_path
        }.from(task_path(id: sample_task.id)).to(login_path)
      end
    end
  end
end