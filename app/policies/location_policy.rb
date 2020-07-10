class LocationPolicy < ApplicationPolicy
  def new?
    return true if user.super_admin?
    return super if record.id.present?

    can_access_at_least_one_organization?
  end

  def edit?
    return true if user.super_admin?
    if scope.any?
      scope.take.admin_emails.include?(user.email)
    end
  end

  def update?
    return true if user.super_admin?
    if scope.any?
      scope.take.admin_emails.include?(user.email)
    end
  end

  def destroy?
    return true if user.super_admin?
    if scope.any?
      scope.take.admin_emails.include?(user.email)
    end
  end

  class Scope < Scope
    def resolve
      return scope.order(:name) if user.super_admin?

      scope.with_email(user.email).order(:name)
    end
  end
end
