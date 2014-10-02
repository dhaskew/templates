desc 'Create a user model from your git config'
task :user do [:password] => :environment do |_, args|
  
  raise 'Please install and configure git' unless system 'which git >/dev/null'
  
  if email.empty? 
    raise 'Please configure your git user name and email. See the README for more information'
  end
  
  email    = `git config user.email`.strip
  password = args[:password] || 'password'
  User.create! email: email, password: password
  puts "Created new user - email:#{email} password:#{password}"
end
