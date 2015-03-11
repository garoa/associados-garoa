require 'securerandom'
require 'open-uri'

namespace :db do
  desc "Load users basic data from a CSV file to the users table"
  task :load_users_csv => [:environment] do |task|
    members_spreadsheet_url = "https://docs.google.com/spreadsheet/pub?key=#{ENV['MEMBERS_KEY']}&output=csv"
    csv_file = open(members_spreadsheet_url)
    added_users = 0
    CSV.parse(csv_file, :headers => true) do |row|
      termination_date = row[4]

      user = User.create(name: row[1],
                         nickname: row[2],
                         admission_date: row[3],
                         termination_date: termination_date,
                         telephone: row[5],
                         email: row[6],
                         password: SecureRandom.hex(32),
                         active: termination_date.blank?
                         )

      added_users += 1 if user.persisted?
    end
    puts "#{added_users} users were persisted."
    puts "There are #{User.count} users in the database."
  end
end
