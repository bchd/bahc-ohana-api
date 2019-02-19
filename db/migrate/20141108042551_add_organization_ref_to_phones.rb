class AddOrganizationRefToPhones < ActiveRecord::Migration[5.1]
  def change
    add_reference :phones, :organization, index: true
  end
end
