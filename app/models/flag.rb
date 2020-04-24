class Flag < ApplicationRecord
 validates :email,
           format: { with: EMAIL_REGEX, message: "Wrong Format"},
           if: -> (flag) { flag.email.present? }

 validates_length_of :description, maximum: 250, allow_blank: false

  def resource
    resource_type.constantize.find(resource_id)
  end

end
