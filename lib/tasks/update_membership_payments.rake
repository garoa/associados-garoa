#encoding: utf-8

require 'open-uri'
require 'chronic'

namespace :db do
  desc "Update membership payments table using CSV (Google Spreadsheet)"
  task :update_membership_payments => [:environment] do |task|
    # TO DO: Move this code outside the rake to test it

    members_spreadsheet_url = "https://docs.google.com/spreadsheets/d/#{ENV['PAYMENTS_KEY']}&single=true&output=csv"

    csv_file = open(members_spreadsheet_url)

    CSV.parse(csv_file, headers: true, row_sep: :auto, col_sep: ",", skip_blanks: true, encoding: "UTF-8").each_with_index do |row, line|

      # skip the first line given that it also has a header
      # skip the line with the total number of members
      # skip lines without emails
      next if (line === 0) || (row["Associado"] === 'Total') || (row["Email"].blank?)

      user_email = row["Email"].to_s.strip

      begin
        membership_date = Chronic.parse(row[9], :endian_precedence => :little) if row[9].present?
      rescue ArgumentError
        puts "Cannot parse this date: #{row[9]}"
      end

      # Check if user has paid the yearly membership and if this membership has expired
      has_paid_yearly_membership = row["Anuidade"].present? && membership_date && (membership_date > Date.today)

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
