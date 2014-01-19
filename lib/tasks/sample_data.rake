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
    
    users_with_posts = User.all(limit: 6)
    users_with_posts.each do |user|
      50.times do
        content = Faker::Lorem.sentence(5)
        user.microposts.create!(content: content)
      end   
    end
        
  end
end