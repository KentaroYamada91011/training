require 'rails_helper'

RSpec.describe 'top page', type: :feature, retry: 7 do
  before do
    subject { page }
    let(:task) { Task.create!(title: '今日のやること') }
    visit ''
    sleep(2)
  end
  it 'page の取得' do
    is_expected.to have_content '今日のやること'
    is_expected.to have_content 'taskの一覧'
    is_expected.to have_content 'task詳細'
  end

  it 'task の削除' do
    # 削除ボタンをクリック
    page.first(".delete-task").click
    is_expected.not_to have_content '今日のやること'
  end

  it 'task の作成' do
    # テキストボックス内でタイトルを入力
    fill_in 'post-title', with: 'post title'
    # テキストボックス内でリターンキーを押下
    find('#post-title').send_keys(:enter)
    is_expected.to have_content 'post title'
  end

  it 'task の title 更新' do
    page.first(".home__main__item").click
    sleep(5)
    fill_in 'title', with: '@'
    sleep(5)
    expect(page.first(".home__main__item")).to have_content '@'
  end

  it 'task の description 更新' do
    page.first(".home__main__item").click
    page.first(".home__description__description").click
    sleep(5)
    fill_in 'description', with: '@'
    sleep(5)
    expect(page.first(".home__description__description")).to have_content '@'
  end
end
