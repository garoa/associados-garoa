#encoding: utf-8

require 'securerandom'
require 'open-uri'

namespace :db do
  desc "Update users table using the Members Spreadsheet"
  task :update_users => [:environment] do |task|
    members_spreadsheet_url = "https://docs.google.com/spreadsheet/pub?key=#{ENV['MEMBERS_KEY']}&output=csv"
    csv_file = open(members_spreadsheet_url)
    added_users = 0

    CSV.parse(csv_file, headers: true, encoding: "UTF-8") do |row|
      termination_date = row[4]

      User.find_or_create_by(email: row[6])
          .update(name: row[1].to_s.force_encoding("UTF-8").encode('UTF-8', undef: :replace, replace: ''),
           nickname: row[2].to_s.force_encoding("UTF-8").encode('UTF-8', undef: :replace, replace: ''),
           admission_date: row[3],
           termination_date: termination_date,
           telephone: row[5],
           email: row[6],
           password: SecureRandom.hex(32),
           active: termination_date.blank?
           )
    end
    puts "There are #{User.count} users in the database."
    puts "There are #{User.active.count} active members."

  end
end
