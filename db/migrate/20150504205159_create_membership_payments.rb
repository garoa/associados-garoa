class CreateMembershipPayments < ActiveRecord::Migration
  def change
    create_table :membership_payments do |t|

      t.integer :overdue_monthly_memberships, :default => 0
      t.integer :starving_months, :default => 0
      t.boolean :yearly_membership, :default => false

      t.references :user
      t.timestamps
    end
  end
end
