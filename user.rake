desc 'Create a user model from your git config'
task :user do
  email    = `git config user.email`.strip
  password = 'password'
  User.create! email: email, password: password
  puts "Created new user - email:#{email} password:#{password}"
end
