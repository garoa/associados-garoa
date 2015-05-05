class MembershipPayment < ActiveRecord::Base
  belongs_to :user

  scope :not_starving, -> { where('starving_months = 0') }
  scope :without_yearly_membership, -> {where(yearly_membership: false) }
end
