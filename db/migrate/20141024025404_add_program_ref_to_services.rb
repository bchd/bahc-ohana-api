class AddProgramRefToServices < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :program, index: true
  end
end
