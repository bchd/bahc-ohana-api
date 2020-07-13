class ServicePolicy < ApplicationPolicy
  def new?
    return true if user.super_admin?

    if user.locations.present?
      return true if scope.take.location.in?(user.locations)
    end
  end

  def create?
    return true if user.super_admin?

    if user.locations.present?
      return true if scope.take.location.in?(user.locations)
    end
  end

  def destroy?
    return true if user.super_admin?

    if user.locations.present?
      return true if scope.take.location.in?(user.locations)
    end
  end

  def update?
    return true if user.super_admin?

    if user.locations.present?
      return true if scope.take.location.in?(user.locations)
    end
  end

  class Scope < Scope
    def resolve
      return scope.order(:name) if user.super_admin?

      scope.with_locations(location_ids).order(:name)
    end
  end

  def archive?
    user.super_admin?
  end
end
