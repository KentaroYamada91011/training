require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task_a) { create(:task1) }
  describe 'Task board' do
    it 'view top page' do
      visit '/board/'
      expect(page).to have_content 'ID'
      expect(page).to have_content 'ユーザー'
      expect(page).to have_content 'ラベル'
      expect(page).to have_content '題名'
      expect(page).to have_content '優先度'
      expect(page).to have_content '状態'
      expect(page).to have_content task_a.subject
    end

    it 'add task' do
      visit '/board/'
      find('#create-button').click
      select I18n.t(:label)[:bugfix], from: 'label'
      fill_in 'subject', with: 'system spec subject'
      fill_in 'description', with: 'system spec description'
      select I18n.t(:priority)[:low], from: 'priority'
      find('#add-task').click
      expect(page).to have_content 'system spec subject'
    end

    it 'change task' do
      visit '/board/'
      find('#id-link-1').click
      find('#change-input').click
      select I18n.t(:label)[:support], from: 'label'
      find('#change-task').click
      expect(page).to have_content I18n.t(:label)[:support]
    end

    it 'change task' do
      visit '/board/'
      find('#button-delete-1').click
      find('#delete-task').click
      expect(page).to_not have_content task_a.subject
    end
  end
end