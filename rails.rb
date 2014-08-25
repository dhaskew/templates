############# SETUP NOTES ####################

# setup rvm
# rvm gemset --create use <project_name>

# install rails
# gem install rails

# execute this script
# rails new <project_name> -m <path_to_template>
# rails new <project_name> -m ~/code/projects/templates/rails.rb
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

case ask("Choose database engine:(postgres, sqlite):", :limited_to => %w[postgres sqlite])
when "postgres"
  gem 'pg'
when "sqlite"
  gem 'sqlite'
end

#install extra gems
run "bundle install"

#convert erb default files to haml
rake "haml:replace_erbs"


#git setup
git :init
git add: "."
git commit: %Q{ -m 'Initial Commit' }


