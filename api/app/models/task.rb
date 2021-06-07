class Task < ApplicationRecord
  enum status: { "not_started": 10, "in_progress": 20, "done": 30 }, _prefix: true
end
