class UpdateServiceStatus < ActiveRecord::Migration[5.1]
  def change
    change_column_null :services, :status, false
    change_column_default :services, :status, 'active'
  end
end
