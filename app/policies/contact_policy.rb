class ContactPolicy < ApplicationPolicy
  def destroy?
    user.super_admin?
  end
end
