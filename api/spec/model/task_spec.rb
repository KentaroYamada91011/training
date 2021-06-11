require 'rails_helper'

describe Task, type: :model do
  describe 'CRUD' do
    it 'taskが正常に作成された場合' do
      task = Task.new(title: 'title')
      expect(task).to be_valid
      expect { task.save }.to change { Task.count }.by(1)
    end

    it 'taskのtitleがないの場合エラー' do
      task = Task.new()
      task.valid?
      expect(task.errors[:title]).to include('を入力してください')
      expect { task.save }.to change { Task.count }.by(0)
    end

    it 'taskのtitleが0文字の場合エラー' do
      task = Task.new(title: '')
      task.valid?
      expect(task.errors[:title]).to include('は1文字以上で入力してください')
      expect { task.save }.to change { Task.count }.by(0)
    end

    it 'taskのtitleが30文字以内であれば正常に作成' do
      task = Task.new(title: 'アイウエオアイウエオアイウエオアイウエオアイウエオアイウエオ')
      expect(task).to be_valid
      expect { task.save }.to change { Task.count }.by(1)
    end

    it 'taskのtitleが30文字を超えるとエラー' do
      task = Task.new(title: 'アイウエオアイウエオアイウエオアイウエオアイウエオアイウエオア')
      task.valid?
      expect(task.errors[:title]).to include('は30文字以内で入力してください')
      expect { task.save }.to change { Task.count }.by(0)
    end

    it 'taskのtitleが255文字以内であれば正常に作成' do
      task = Task.new(title: 'アイウエオ', description: 'アイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオ')
      task.valid?
      expect(task).to be_valid
      expect { task.save }.to change { Task.count }.by(1)
    end

    it 'taskのtitleが255文字を超えるとエラー' do
      task = Task.new(title: 'アイウエオ', description: 'アイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオアイウエオア')
      task.valid?
      expect(task.errors[:description]).to include('は255文字以内で入力してください')
      expect { task.save }.to change { Task.count }.by(0)
    end
  end

  describe '検索' do
    let!(:task1) {create(:task1, title: 'hoge', status: '未着手') }
    let!(:task2) {create(:task2, title: 'fuga', status: '進行中') }
    let!(:task3) {create(:task3, title: 'piyo', status: '終了') }

    it 'status 設定なしで record が見つかった場合' do
      tasks = Task.search({title: 'fuga', status: '全て'})
      expect(tasks.size).to eq (1)
      expect(tasks).to include(task2)
    end

    it 'status を設定し、 record が見つかった場合' do
      tasks = Task.search({title: 'fuga', status: '進行中'})
      expect(tasks.size).to eq (1)
      expect(tasks).to include(task2)
    end

    it 'record が見つからない場合' do
      tasks = Task.search({title: 'fige', status: '終了'})
      expect(tasks.size).to eq (0)
    end
  end
end
