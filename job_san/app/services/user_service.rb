# frozen_string_literal: true

class UserService
  def initialize(user, login_user)
    @update_user = user
    @login_user = login_user
  end

  def update_user(params)
    return @update_user unless updatable_role_type?(params[:role_type])

    @update_user.update(params.except(:id))
    @update_user
  end

  private

  def updatable_role_type?(role_type)
    return true if role_type.blank?

    @update_user.errors.add(:role_type, :invalid) unless %w[admin member].include?(role_type)
    @update_user.errors.add(:base, I18n.t('user.error.last_admin')) if last_admin? && update_own? && role_type == User::MEMBER_ROLE
    @update_user.errors.blank?
  end

  def update_own?
    @login_user.id == @update_user.id
  end

  def last_admin?
    User.admin.count < 2
  end
end