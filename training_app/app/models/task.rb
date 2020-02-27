# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  status     :integer          default("todo"), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_tasks_on_status   (status)
#  index_tasks_on_user_id  (user_id)
#

class Task < ApplicationRecord
  belongs_to :user

  has_many :task_labels
  has_many :labels, through: :task_labels, autosave: false

  validates :title, presence: true
  validates :body, presence: true

  enum status: {
    todo: 0,
    progress: 1,
    done: 2,
  }

  attr_accessor :label

  def self.status_name(status)
    I18n.t("activerecord.enums.task.status.#{status}")
  end

  def status_name
    self.class.status_name(self.status)
  end
end