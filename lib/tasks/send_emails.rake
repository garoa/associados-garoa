namespace :email do
  desc 'Send an email to all active Garoa members that did not pay the yearly fee so they remember to pay the monthly fee'
  task :monthly_membership => :environment do
    User.need_to_receive_monthly_email.find_each do |user|
      MonthlyMembershipMailer.remember_to_pay(user).deliver
    end
  end

  desc 'Send an email to googlegroups with a list with all members with overdue membership payments'
  task :overdue_memberships => :environment do
    MonthlyMembershipMailer.users_with_overdue_membership.deliver
  end

end
