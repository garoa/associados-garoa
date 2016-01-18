class MembershipPayment < ActiveRecord::Base
  belongs_to :user

  scope :overdue_memberships, -> { where('overdue_monthly_memberships > 0')}
  scope :not_starving, -> { where('starving_months = 0') }
  scope :without_yearly_membership, -> {where(yearly_membership: false) }
end
