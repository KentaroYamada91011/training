require 'rails_helper'

RSpec.describe TasksController, type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  before do
    login_as user
  end

  describe 'POST /tasks' do
    it 'lets a user create a task' do
      expect { post '/tasks', params: { task: { name: 'A', description: 'A!', priority: :normal, status: :waiting } } }
        .to change { Task.count }.by(1)
      task = Task.find_by(name: 'A')
      expect(task).to be_valid
      expect(task.user).to eq user
    end
  end

  describe 'PATCH /tasks/:id' do
    it 'lets a user edit a task' do
      expect { patch "/tasks/#{task.id}", params: { task: { name: 'Changed!' } } }
        .to change { task.reload.name }.to('Changed!')
    end

    it "disallows a user to edit another user's task" do
      another_user = create(:user)
      another_task = create(:task, user: another_user)
      expect { patch "/tasks/#{another_task.id}", params: { task: { name: 'Changed!' } } }
        .to not_change { task.reload.name }.and raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'lets a user delete a task' do
      task_id = task.id
      expect { delete "/tasks/#{task.id}" }.to change { Task.count }.by(-1)
      expect(Task.exists?(task_id)).to be false
    end

    it "disallows a user to delete another user's task" do
      another_user = create(:user)
      another_task = create(:task, user: another_user)
      expect { delete "/tasks/#{another_task.id}" }.to not_change { Task.count }.and raise_error ActiveRecord::RecordNotFound
      expect(another_task).to be_persisted
    end
  end
end
