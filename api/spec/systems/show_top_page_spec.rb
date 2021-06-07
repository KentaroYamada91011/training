require 'rails_helper'

RSpec.describe 'top page', type: :feature do
  before do
    @task = Task.create!(title: '今日のやること')
  end
  it 'page の取得' do
    visit ''
    sleep(2)
    expect(page).to have_content 'taskの一覧'
    expect(page).to have_content 'task詳細'
    binding.pry
    expect(page).to have_content 'task詳細'
  end
end
