module UserHelper
  def username(user)
    name = "#{user.first_name} #{user.last_name}".strip
    name = user.email if name.blank?
    name
  end

  def delete_confirmation(user)
    if user == current_user
      "alert('#{t('devise.registrations.cant_delete_self')}'); return false;"
    else
      "return confirm('#{t('devise.registrations.confirm_delete_user', username: username(user))}');"
    end
  end
end
