class Task < ApplicationRecord
  enum status: { "未着手": 1, "着手": 2, "完了": 3 }, _prefix: true
  after_initialize :set_default_values

  def set_default_values
    self.description         ||= ""
    self.deadline            ||= "9999-12-31 23:59:59"
    self.status              ||= 1
    self.parent_id           ||= 0
    self.user_id             ||= 1
  end
end
