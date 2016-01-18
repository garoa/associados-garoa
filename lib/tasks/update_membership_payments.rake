#encoding: utf-8

require 'open-uri'

namespace :db do
  desc "Update membership payments table using CSV (Google Spreadsheet)"
  task :update_membership_payments => [:environment] do |task|
    members_spreadsheet_url = "https://docs.google.com/spreadsheets/d/#{ENV['PAYMENTS_KEY']}&single=true&output=csv"
    puts members_spreadsheet_url
    csv_file = open(members_spreadsheet_url)

    CSV.parse(csv_file, headers: true, row_sep: :auto, col_sep: ",", encoding: "UTF-8") do |row|
      user_email = row["Email"].to_s.strip
      has_paid_yearly_membership = row["Anuidade"].present?

      if user_email.present?
        begin
          User.find_by!(email: user_email).tap do |user|
              mp = MembershipPayment.find_or_initialize_by(user_id: user.id)
              mp.update(
                  yearly_membership: has_paid_yearly_membership,
                  overdue_monthly_memberships: row['Atraso'].to_i,
                  starving_months: row['Starving'].to_i
                  )
              mp.save!
          end
        rescue ActiveRecord::RecordNotFound
          puts "User with email '#{user_email}' not found, please fix the email in the spreadsheet or run the task to update the users"
        end
      end

    end

  end
end
