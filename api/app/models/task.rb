class Task < ApplicationRecord
  enum status: { "not_started": 10, "in_progress": 20, "done": 30 }, _prefix: true
  after_initialize :set_default_values

  def set_default_values
    self.description         ||= ""
    self.deadline            ||= "9999-12-31 23:59:59"
    self.status              ||= 10
    self.parent_id           ||= 0
    self.user_id             ||= 1
  end
end
