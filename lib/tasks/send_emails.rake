namespace :email do
  desc 'Send and email to all active Garoa members so they remember to pay the monthly fee'
  task :monthly_fee => :environment do
    User.active.find_each do |user|
      MonthlyFeeMailer.remember_to_pay(user).deliver
    end
  end

  desc 'Send and email to all active Garoa members that have overdue fees'
  task :monthly_fee => :environment do
    # IMPLEMENT
  end
end
