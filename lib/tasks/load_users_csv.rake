require 'securerandom'

CSV_FILE = 'garoa_hc_associados.csv'

namespace :db do
  task :load_users_csv => :environment do
    users = 0
    CSV.foreach(Rails.root + "db/data/#{CSV_FILE}",
                :headers => :first_row,
                :col_sep => "\t"
                ) do |row|
      user = User.create(name: row[1],
                         nickname: row[2],
                         admission_date: row[3],
                         termination_date: row[4],
                         telephone: row[5],
                         email: row[6],
                         password: SecureRandom.hex(32))
      debugger
      users += 1 if user.valid?
    end
    puts "#{users} users were created."
  end
end