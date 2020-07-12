class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.order(:name) if user.super_admin?

      scope.with_locations(location_ids).order(:name)
    end
  end
end
