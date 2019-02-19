class AddServiceRefToPhones < ActiveRecord::Migration[5.1]
  def change
    add_reference :phones, :service, index: true
  end
end
