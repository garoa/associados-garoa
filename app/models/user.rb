class User < ActiveRecord::Base

  YEARLY_MEMBERSHIP_MONTH = 2

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :membership_payment, dependent: :destroy

  delegate :overdue_monthly_memberships, to: :membership_payment, allow_nil: true

  scope :active, -> { where(active: true) }

  scope :inactive, -> { where(active: false) }

  def self.with_overdue_monthly_memberships(overdue_memberships = 0)
    active.
    joins(:membership_payment)
    .merge(MembershipPayment.without_yearly_membership.not_starving
    .where('overdue_monthly_memberships > ?', overdue_memberships))
    .order('membership_payments.overdue_monthly_memberships DESC')
  end

  # Get all users that need to receive the monthly membership email, i.e.:
  # - Users that are active;
  # - Users that did not pay for a yearly membership;
  # - Users that are not in the 'starving hackers' program.
  # - In the the month in which yearly memberships are paid, all user must
  #  receive the email.


  def self.need_to_receive_monthly_email
    if Date.today.month == YEARLY_MEMBERSHIP_MONTH
      self.active
          .joins(:membership_payment)
    else
      self.active
          .joins(:membership_payment)
          .merge(MembershipPayment.without_yearly_membership.not_starving)
    end
  end

  def aka
    nickname.present? ? nickname : name
  end

  def has_overdue_membership_payments?
    overdue_monthly_memberships.to_i > 0
  end

end
