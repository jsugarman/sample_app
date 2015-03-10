namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end

  # ----------------------
  def make_users
    
    # 
    # create an admin user
    # 
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)
    
    # 
    # create may standard users
    # 
    99.times do |n|
      
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   activated: true,
                   activated_at: Time.zone.now)
    end
  end
  
  # ----------------------
  def make_microposts
    # 
    # create 50 micropost each for any 6 users
    # 
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
    
  # ----------------------
  def make_relationships
    users = User.all
    user  = users.first
    followers       = users[3..41]
    followed_users  = users[2..50]
    followers.each { |follower| follower.follow!(user) }
    followed_users.each { |followed_user| user.follow!(followed_user) }
  end


end