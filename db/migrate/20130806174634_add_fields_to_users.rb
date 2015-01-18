class AddFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :name
      t.string :nickname
      t.string :telephone
      t.boolean :active
      t.date :admission_date
      t.date :termination_date
    end
  end
end
