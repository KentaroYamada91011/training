class Task < ApplicationRecord
  enum status: { "not_started": 10, "in_progress": 20, "done": 30 }, _prefix: true
  validates :title, presence: true, length: { maximum: 30 }, allow_blank: false
  validates :description, length: { maximum: 255 }
end
