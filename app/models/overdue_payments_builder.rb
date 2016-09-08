class OverduePaymentsBuilder

  def initialize
  end

  # Returns a list with user names and the number of overdue payments in parenthesis:
  # Eg.:
  #  - John (2)
  #  - George (2)
  #  - Ringo (1)
  #  - Paul (3)

  def build_users_list
    User.with_overdue_monthly_memberships.inject([]) do |list, user|
      list << "- #{user.aka} (#{user.overdue_monthly_memberships.to_i})"
    end.join("\n")
  end

end
