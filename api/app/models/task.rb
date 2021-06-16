class Task < ApplicationRecord
  enum status: { I18n.t('status.not_started') => 10, I18n.t('status.in_progress') => 20, I18n.t('status.done') => 30 }, _prefix: true
  validates :title, presence: true, length: { maximum: 30 }, allow_blank: false
  validates :description, length: { maximum: 255 }
  def self.search(search)
    return Task.all if search[:status].nil? && search[:title].nil?
    if search[:status] == "全て"
      Task.where('title like ?',"%#{search[:title]}%")
    else
      Task.where(status: search[:status]).where('title like ?',"%#{search[:title]}%")
    end
  end
end
