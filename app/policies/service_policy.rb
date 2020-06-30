class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
<<<<<<< HEAD
      return scope.order(:name) if user.super_admin?
=======
      return scope.pluck(:location_id, :id, :name, :archived_at).sort_by(&:third) if user.super_admin?
>>>>>>> 35dc1ce78e989761bc42f9a793edb3bece452cdc

      scope.with_locations(location_ids).order(:name)
    end
  end
end
