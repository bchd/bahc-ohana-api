class CategoryPolicy < ApplicationPolicy

  def create?
    user.super_admin?
  end

  def new?
    user.super_admin?
  end

  def edit?
    user.super_admin?
  end

  def destroy?
    user.super_admin?
  end

  def update?
    user.super_admin?
  end

  def show?
    user.super_admin?
  end
end
