require 'securerandom'

namespace :db do
  desc "Load users basic data from a CSV file to the users table"
  task :load_users_csv, [:filename] => [:environment] do |task, args|
    filename = args[:filename] || 'garoa_hc_associados_dummy.csv'
    added_users = 0
    CSV.foreach(Rails.root + "db/data/#{filename}", :headers => :first_row) do |row|

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
