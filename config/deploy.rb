# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.2'

set :application, 'QnA'
set :repo_url, 'git@github.com:vsav/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/qna'
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

after 'deploy:publishing', 'unicorn:restart'
