namespace :db do
  namespace :seed do
    desc "seed User information"
    task :user => :environment do
      User.create!(email: ENV['USER_EMAIL'], password: ENV['USER_PASSWORD'], password_confirmation: ENV['USER_PASSWORD'])
      p "created user successfully!"
    end
  end
end