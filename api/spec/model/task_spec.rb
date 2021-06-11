require 'rails_helper'

describe Task, type: :model do
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
