namespace :email do
  desc 'Send and email to all active Garoa members so they remember to pay the monthly fee'
  task :monthly_membership => :environment do
    User.need_to_receive_monthly_email.find_each do |user|
      MonthlyMembershipMailer.remember_to_pay(user).deliver
    end
  end

end
