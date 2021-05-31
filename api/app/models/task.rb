class Task < ApplicationRecord
    enum status: { "未着手": 1, "着手": 2, "完了": 3 }, _prefix: true
end
