class TagPolicy < ApplicationPolicy

  def create?
    return true if user.super_admin?
  end

  def new?
    return true if user.super_admin?
  end

  def edit?
    return true if user.super_admin?
  end

  def destroy?
    return true if user.super_admin?
  end

  def update?
    return true if user.super_admin?
  end
end