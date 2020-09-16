require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:task_status_untouch) { create(:untouch) }
  let!(:task_status_in_progress) { create(:in_progress) }
  let!(:task_status_finished) { create(:finished) }
  let!(:test_user) { create(:test_user) }

  it 'is invalid without title and description' do
    new_task = Task.new(user_id: test_user.id)
    new_task.valid?
    expect(new_task.errors.messages[:title]).to include('を入力してください')
    expect(new_task.errors.messages[:description]).to include('を入力してください')
  end

  describe 'search' do
    let(:untouch_condition) { {task_status_id: task_status_untouch.id} }
    let(:in_progress_condition) { {task_status_id: task_status_in_progress.id} }
    let(:finished_condition) { {task_status_id: task_status_finished.id} }
    before do
      sample_status_ids = [task_status_untouch.id]
      2.times {sample_status_ids.push(task_status_in_progress.id)}
      3.times {sample_status_ids.push(task_status_finished.id)}
      sample_status_ids.each do |status_id|
        Task.create(user_id: test_user.id, title: "test title", description: "test description", task_status_id: status_id)
      end
    end
    it 'shoud match correct records count' do
      expect(Task.search(test_user.id, untouch_condition).count).to eq 1
      expect(Task.search(test_user.id, in_progress_condition).count).to eq 2
      expect(Task.search(test_user.id, finished_condition).count).to eq 3
    end
  end
end
