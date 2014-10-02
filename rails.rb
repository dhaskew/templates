############# SETUP NOTES ####################

# setup rvm
# rvm gemset --create use <project_name>

# install rails
# gem install rails

# execute this script
# rails new <project_name> -m <path_to_template>
# rails new <project_name> -B -d postgresql -m ~/code/projects/templates/rails.rb
# rails new <project_name> -m https://raw.githubusercontent.com/dhaskew/templates/master/rails.rb

# useful bash alias idea
# alias rtemp='curl https://raw.githubusercontent.com/dhaskew/templates/master/rails.rb'

#############  START ACTUAL CODE ##############

gem 'haml-rails'

gem_group :development do
  gem 'annotate'           #adds table info to models via 'annotate' command
  gem 'better_errors'      #better landing page for errors
  gem 'binding_of_caller'  #command line on better landing page
  gem 'pry-rails'          #integrate pry, specifically for "rails c"
  gem 'quiet_assets'
  #gem 'bullet'
  gem 'erb2haml'           #rake haml:replace_erbs
end

setup_devise = false

case ask("Setup Devise?:(yes, no):", :limited_to => %w[yes no])
when "yes"
  gem 'devise'
  setup_devise = true
end

#install extra gems
say "Running bundle install"
run "bundle install"

run "rails generate devise:install" if setup_devise
run "rails generate devise User" if setup_devise

#convert erb default files to haml
say "running erb to haml conversion"
rake "haml:replace_erbs"

run "bundle exec spring binstub --all"

# download useful rake tasks?
# james had some here : https://github.com/theironyard-rails-atl/js-game-demo
#inside('vendor') do
#    run "ln -s ~/commit-rails/rails rails"
#end

#git setup
git :init
git add: "."
git commit: %Q{ -m 'Initial Commit' }

puts "#"*50
puts "Things left to do --> "
puts "rake db:create"
puts "rake db:migrate"
puts "----Devise Setup---"
puts "update: config/environments/development.rb"
puts "add: config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
puts "Update Application Controller with :"
puts "before_action :authenticate_user!"
puts "----End Devise Setup---"
puts "setup the root route to something"
puts "#"*50



