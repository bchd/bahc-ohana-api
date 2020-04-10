class Flag < ApplicationRecord
 has_one :organization
 has_many :flag_categories

 validates :reported_by_email,
           format: { with: EMAIL_REGEX, message: "Wrong Format"},
           if: -> (flag) { flag.reported_by_email.present? }

 validates_length_of :description, maximum: 250, allow_blank: false

end
