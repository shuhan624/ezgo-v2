require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'ezgo'
# setup multiple ssh keys in web-deploy@app.cianwang.com:~/.ssh/config
# so modify the ssh host to "github.jade-swallow"
set :repository, 'git@github.ezgo:CianWang/ezgo.git'

task :pro do
  set :rails_env, 'production'
  set :domain, 'pro3.cianwang.com'
  set :branch, 'master'
  set :deploy_to, '/var/www/ezgo'
  set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/credentials/production.key', 'config/google-data-api-credential.json')
end

task :staging do
  set :keep_releases, 3
  set :hostname, 'ezgo.cw1.dev'
  set :admin_hostname, 'admin.ezgo.cw1.dev'
  set :rails_env, 'staging'
  set :domain, 'cw1.dev'
  set :branch, 'master'
  set :deploy_to, '/var/www/ezgo-dev'
  set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/credentials/staging.key', 'config/google-data-api-credential.json')
end

# Optional settings:
set :user, 'web-deploy'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('node_modules', 'log', 'tmp/pids', 'tmp/sockets', 'public/assets', 'public/packs', 'public/fonts', 'storage')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

desc "Pre-Setup needs sudo permission."
task :presetup do
  set :user, 'pingyen'

  # 1. Create Folder
  comment 'Creating Website Folder...'
  command %{ sudo mkdir -p #{fetch(:deploy_to)} }
  command %{ sudo chown web-deploy:web-deploy #{fetch(:deploy_to)} }

  # 2. copy file and change owner to root
  invoke :set_nginx_config
  `scp tmp/nginx_config.conf #{fetch(:user)}@#{fetch(:domain)}:~/`
  command %{ sudo chown root:root ~/nginx_config.conf }

  # 3. Setup Site in Nginx
  command %{ sudo mv ~/nginx_config.conf /etc/nginx/sites-available/#{fetch(:application_name)}-dev }
  command "sudo ln -s /etc/nginx/sites-available/#{fetch(:application_name)}-dev /etc/nginx/sites-enabled/#{fetch(:application_name)}-dev"
  # TODOs
  # Need to Update nginx config file
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # generate SSH key
  key_filename = "id_rsa_#{fetch(:application_name)}"
  command %{ ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/#{key_filename}" -C '#{fetch(:user)}@#{fetch(:domain)}' -N '' }
  command %{ echo -e '# GitHub #{fetch(:application_name)} Repo\nHost github.#{fetch(:application_name)}\n\tHostName github.com\n\tUser git\n\tAddKeysToAgent yes\n\tIdentityFile ~/.ssh/#{key_filename}\n' >> "$HOME/.ssh/config" }
  command %{cat "$HOME/.ssh/#{key_filename}.pub" }
  # scp credential files
  in_path(fetch(:deploy_to)) do
    command %{ rbenv local 3.3.5 }
  end
end

task :postsetup do
  `scp config/database.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:deploy_to)}/shared/config/database.yml`
  `scp config/credentials/#{fetch(:rails_env)}.key #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:deploy_to)}/shared/config/credentials/#{fetch(:rails_env)}.key`
end

task :certbot do
  # 4. Generate Certs (SSL)
  set :user, 'pingyen'
  command "sudo certbot --nginx -n --agree-tos --redirect --email leo.chen@cianwang.com -d #{fetch(:hostname)} -d #{fetch(:admin_hostname)}"
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'sitemap:refresh' if 'production' == fetch(:rails_env)
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

task :restart do
  in_path(fetch(:deploy_to)) do
    command 'touch current/tmp/restart.txt'
  end
end

task :'sitemap:refresh' do
  # TODO: need to run or set cronjob for generating sitemap.xml
  # Update to sitemap:refresh when go production (remove "no_ping")
  # command %{RAILS_ENV=production bundle exec rake sitemap:refresh}
  command %{RAILS_ENV=production bundle exec rake sitemap:refresh:no_ping CONFIG_FILE='config/sitemap_tw.rb'}
  command %{RAILS_ENV=production bundle exec rake sitemap:refresh:no_ping CONFIG_FILE='config/sitemap_en.rb'}
end

desc "Seed data to the database"
task :seed do
  in_path(fetch(:current_path)) do
    command %{ RAILS_ENV=#{fetch(:rails_env)} bundle exec rake db:seed }
  end
end

task :set_nginx_config do
  nginx_config = <<~EOF
    server {
        server_name #{fetch(:hostname)} #{fetch(:admin_hostname)};
        root /var/www/#{fetch(:application_name)}-dev/current/public;

        rails_env "#{fetch(:rails_env)}";
        passenger_enabled on;
        passenger_ruby /home/web-deploy/.rbenv/shims/ruby;

        # No "location" before passenger settings

        location ~ ^/(assets|packs)/ {
          expires 1y;
          gzip on;
          gzip_comp_level 6;
          gzip_min_length 1024;
          gzip_static on;
          gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;
          add_header Cache-Control public;
          add_header ETag \"\";
          break;
        }

        error_page 404 /404;

        error_page 500 502 503 504 /500.html;
        location = /500.html {
          root /var/www/#{fetch(:application_name)}-dev/current/public;
        }

        listen [::]:80;
        listen 80;
    }
  EOF

  # 將配置寫入臨時文件
  File.open('tmp/nginx_config.conf', 'w') do |file|
    file.write(nginx_config)
  end
  puts "Nginx 配置文件已保存到 'tmp/nginx_config.conf'"
end
