namespace :db do
  desc "Fill db with sample users"
  task populate: :environment do
    User.create!(name: "Admin", 
        email: "admin@example.com",
        password: "password",
        password_confirmation: "password", admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "foobar"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
        
  end
end