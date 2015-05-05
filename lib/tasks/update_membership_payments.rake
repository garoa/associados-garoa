#encoding: utf-8

require 'open-uri'

namespace :db do
  desc "Update membership payments table using CSV (Google Spreadsheet)"
  task :update_membership_payments => [:environment] do |task|
    members_spreadsheet_url = "https://docs.google.com/spreadsheet/pub?key=#{ENV['PAYMENTS_KEY']}&output=csv"
    csv_file = open(members_spreadsheet_url)

    CSV.parse(csv_file, headers: true, encoding: "UTF-8") do |row|
      user_email = row["Email"].to_s.strip
      has_paid_yearly_membership = row["Anuidade"].present?

      if user_email.present?
        begin
          User.find_by!(email: user_email)
              .create_membership_payment(
                yearly_membership: has_paid_yearly_membership,
                overdue_monthly_memberships: row['Atraso'].to_i,
                starving_months: row['Starving'].to_i
                )
        rescue ActiveRecord::RecordNotFound
          puts "User with email '#{user_email}' not found"
        end
      end

    end

  end
end
