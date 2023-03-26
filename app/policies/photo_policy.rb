class PhotoPolicy < ApplicationPolicy
  def create?
    user.user.present?
  end

  def destroy?
    update?
  end

  def edit?
    update?
  end

  def show?
  end

  def update?
    user_is_owner?
  end

  private

  def user_is_owner?
    user.user.present? && (record.try(:user) == user.user)
  end
end
