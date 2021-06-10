class Task < ApplicationRecord
  enum status: { I18n.t('status.not_started') => 10, I18n.t('status.in_progress') => 20, I18n.t('status.done') => 30 }, _prefix: true
end
