class Label < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: true }
  validate :check_color

  private

  def check_color
    return errors.add(:color, :blank) unless color

    case color
    when /\A#\h{3}\z/
      # OK
    when /\A#\h{6}\z/
      # OK
    when /\A#\h{8}\z/
      # OK
    else
      errors.add(:color, :hexadecimal_notation)
    end
  end
end
