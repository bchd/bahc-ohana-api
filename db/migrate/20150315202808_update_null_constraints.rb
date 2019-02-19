class UpdateNullConstraints < ActiveRecord::Migration[5.1]
  def change
    change_column_null :services, :application_process, true
  end
end
