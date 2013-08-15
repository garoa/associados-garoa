namespace :email do
  task :monthly_fee => :environment do
    User.active.find_each do |user|
      puts 'testing'
      MonthlyFeeMailer.remember_to_pay_email(user).deliver
    end
  end
end