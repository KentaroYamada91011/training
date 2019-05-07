# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/new', type: :view do
  before(:each) do
    assign(:task, Task.new())
  end

  xit 'renders new task form' do
    render

    assert_select 'form[action=?][method=?]', tasks_path, 'post' do
    end
  end
end