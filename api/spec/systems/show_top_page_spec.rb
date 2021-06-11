require 'rails_helper'

RSpec.describe 'top page', type: :feature, retry: 7 do
  subject { page }
  let!(:task1) {create(:task1, title: '今日のやること') }
  let!(:task2) {create(:task2, title: '期限間近', deadline: '2021-06-31T23:59') }
  let!(:task3) {create(:task3, title: '期限まだ先', deadline: '2022-06-31T23:59') }
  before do
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
    fill_in 'home-title', with: '@'
    sleep(5)
    expect(page.first(".home__main__item")).to have_content '@'
  end

  it 'task の description 更新' do
    page.first(".home__main__item").click
    page.first(".home__description__description").click
    sleep(5)
    fill_in 'home-description', with: '@'
    sleep(5)
    expect(page.first(".home__description__description")).to have_content '@'
  end

  it 'task を期限順に並び替え' do
    page.first(".home__sort__button").click
    message = task2.id.to_s + '.期限間近'
    sleep(5)
    expect(page.first(".home__main__title")).to have_content message
  end

  describe 'task の 検索' do
    it 'record が見つかった場合' do
      page.first("#header-title").click
      fill_in 'header-title', with: '期限間近'
      page.first("#search").click
      sleep(5)
      is_expected.to have_content '期限間近'
    end

    it 'record が見つからない場合' do
      page.first("#header-title").click
      fill_in 'header-title', with: '期間近'
      page.first("#search").click
      sleep(5)
      is_expected.not_to have_content '期限間近'
    end
  end
end
