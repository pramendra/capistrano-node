# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'uq'
set :repo_url, 'git@bitbucket.org:PramFR/uq.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
set :deploy_to, -> { "/home/ubuntu/#{fetch(:application)}" }
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{node_modules bower_components packages/contrib files}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
namespace :npm do
  task :install do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :npm, "install"
      end
    end
  end
end

namespace :node do

  desc 'Restart Node'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # puts "cd #{deploy_to}/current && NODE_ENV=#{fetch(:stage)} forever restart server.js"
      # execute "cd #{deploy_to}/current && sudo NODE_ENV=#{fetch(:stage)} forever restart server.js"
      # sudo to run on port 80
      sudo "kill -QUIT `ps aux | grep -E 'node.*server.js'| grep -v grep | awk '{print $2}'`"
      execute "cd #{deploy_to}/current && sudo NODE_ENV=#{fetch(:stage)} forever start server.js"
    end
  end

  desc 'Start Node'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{deploy_to}/current && sudo NODE_ENV=#{fetch(:stage)} forever start server.js"
    end
  end

  desc 'Stop Node'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      # execute "cd #{deploy_to}/current && forever stop server.js"
      sudo "kill -QUIT `ps aux | grep -E 'node.*server.js'| grep -v grep | awk '{print $2}'`"

    end
  end
end

namespace :mongo do

  desc 'Restart Node'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :service, :mongodb, :restart
    end
  end

  desc 'Start Mongo'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute :service, :mongodb, :start
    end
  end

  desc 'Stop Mongo'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute :service, :mongodb, :stop
    end
  end
end

namespace :grunt do
  task :install do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        # execute :sudo, :bower, "cache clean"
        # execute :sudo, :bower, "install --allow-root"
        execute :bower, "cache clean"
        execute :bower, "install"
      end
    end
  end
  task :build do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :sudo, :grunt, "heroku:production"
      end
    end
  end

end