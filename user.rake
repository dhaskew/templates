desc 'Create a user model from your git config'
task :user, [:password] => :environment do |_, args|
  
  raise 'Please install and configure git' unless system 'which git >/dev/null'
  
  email    = `git config user.email`.strip
  
  if email.empty? 
    raise 'Please configure your git user name and email. See the README for more information'
  end

  password = args[:password] || 'password'
  User.create! email: email, password: password
  puts "Created new user - email:#{email} password:#{password}"
end
