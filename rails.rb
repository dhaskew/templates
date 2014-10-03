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
gem 'twitter-bootstrap-rails'

gem_group :development do
  gem 'annotate'           #adds table info to models via 'annotate' command
  gem 'better_errors'      #better landing page for errors
  gem 'binding_of_caller'  #command line on better landing page
  gem 'pry-rails'          #integrate pry, specifically for "rails c"
  gem 'quiet_assets'
  #gem 'bullet'
  gem 'erb2haml'           #rake haml:replace_erbs
end

gem_group :development, :test do
  gem 'factory_girl_rails', require: false
  gem 'rspec-rails'
end

gem_group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'simplecov'
end

setup_devise = false

if yes?("Setup Devise?")
  gem 'devise'
  setup_devise = true 
end
#case ask("Setup Devise?:(yes, no):", :limited_to => %w[yes no])
#when "yes"
#  gem 'devise'
#  setup_devise = true
#end

# Remove Turbolinks
say 'Silly turbolinks. Delete...'
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''


#install extra gems
say "Running bundle install"
run "bundle install"


#convert erb default files to haml
say "running erb to haml conversion"
rake "haml:replace_erbs"

# Remove Turbolink Remnants
gsub_file('app/views/layouts/application.html.haml', /\, \'data-turbolinks-track\' => true/, '')
gsub_file('app/assets/javascripts/application.js', /\= require turbolinks/, '')

run "bundle exec spring binstub --all"

# download useful rake tasks?
# james had some here : https://github.com/theironyard-rails-atl/js-game-demo
#inside('vendor') do
#    run "ln -s ~/commit-rails/rails rails"
#end
say "setting default route to 'misc_pages#index'"
route "root to: 'misc_pages#index'"

say "fetching rake tasks"
run "curl --output lib/tasks/user.rake https://raw.githubusercontent.com/dhaskew/templates/master/user.rake"


say "setting up database - Development"
rake "db:create", env: 'development'
rake "db:migrate", env: 'development'

say "setting up database - Test"
rake "db:create", env: 'test'
rake "db:migrate", env: 'test'

#git setup
git :init
git add: "."
git commit: %Q{ -m 'Template: Initial Commit' }

say "setting up rspec"
run "rm -r test"
run "rails generate rspec:install"
git add: "."
git commit: %Q{ -m 'Template: Initial Rspec Setup' }

#basic bootstrap setup
say "running basic bootstrap setup"
run "rails generate bootstrap:install static"
run "rails generate bootstrap:layout application fluid -f"
git add: "."
git commit: %Q{ -m 'Template: Bootstrap Setup" }

say "generating a basic misc_pages_controller"
#run "rails g controller MiscPages index"
generate(:controller, "MiscPages index")

git add: "."
git commit: %Q{ -m 'Template: MiscPages Controller' }

#say "fetching basic ApplicationHelper"
#run "curl --output app/helpers/application_helper.rb https://raw.githubusercontent.com/dhaskew/templates/master/application_helper.rb"
#git add: "."
#git commit: %Q{ -m 'Template: application_helper.rb' }


#basic devise setup
if setup_devise
  say "setting up devise"
  run "rails generate devise:install"
  run "rails generate devise User"

  say "Migrating Database - Development"
  rake "db:migrate", env: 'development'

  say "Migrating Database - Test"
  rake "db:migrate", env: 'test'

  environment 'config.action_mailer.default_url_options = {host: "localhost", port: 3000}', env: 'development'

  git add: "."
  git commit: %Q{ -m 'Template: Basic Devise Setup' }
end

#say "fetching flash example"
#run "curl --output flash.haml https://raw.githubusercontent.com/dhaskew/templates/master/flash.haml"

puts "#"*50
puts "Things left to do --> "
puts "----Devise Setup---"
puts "needed? : update: config/environments/development.rb"
puts "add: config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
puts "Update Application Controller with :"
puts "before_action :authenticate_user!"
puts "----End Devise Setup---"

#puts "Remove turbolinks support: "
#puts "* update gemfile"
#puts "* update site template"
#puts "* update application.js"

#puts "add flash support to application layout"
#puts "review flash.haml, then delete"
puts "run rake user - to create starting admin user"

puts "#"*50



