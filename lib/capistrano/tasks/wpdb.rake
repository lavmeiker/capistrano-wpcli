namespace :load do
  task :defaults do
    set :application,  ENV["WP_APP_NAME"]
    # A temp dir which is read and writeable by the capistrano
    # deploy user
    set :remote_tmp_dir, ENV["WP_REMOTE_TMP"] || "/tmp"

    # A local temp dir which is read and writeable
    set :local_tmp_dir, ENV["WP_LOCAL_TMP"] || "/tmp"

    # The url under which the wordpress installation is
    # available on the remote server
    set :remote_url, ENV["WP_REMOTE_URL"]

    # The url under which the wordpress installation is
    # available on the local server
    set :local_url, ENV["WP_HOME"]
    
    # Shortcuts
    set :remote_db_file, "#{fetch(:remote_tmp_dir)}/#{fetch(:application)}_database.sql"
    set :local_db_file, "#{fetch(:local_tmp_dir)}/#{fetch(:application)}_database.sql"
  end
end

namespace :wpcli do
  namespace :db do
    desc "Pull the remote database"
    task :pull do
      on roles(:web) do
        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            execute :wp, "db export",  fetch(:remote_db_file)
            download! fetch(:remote_db_file), fetch(:local_db_file)
            execute :rm, fetch(:remote_db_file)
          end
        end

        run_locally do
          execute :wp, "db import", fetch(:local_db_file)
          execute :rm, "#{fetch(:local_db_file)}"
          execute :wp, "search-replace", "'#{fetch(:remote_url)}' '#{fetch(:local_url)}' --skip-columns=guid"
        end
      end
    end

    desc "Push the local database"
    task :push do
      on roles(:web) do
        run_locally do
          execute :wp, "db export", fetch(:local_db_file)
        end

        upload! fetch(:local_db_file), fetch(:remote_db_file)

        run_locally do
          execute :rm, fetch(:local_db_file)
        end

        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            execute :wp, "db import", fetch(:remote_db_file)
            execute :rm, fetch(:remote_db_file)
            execute :wp, "search-replace", "'#{fetch(:local_url)}' '#{fetch(:remote_url)}' --skip-columns=guid"
          end
        end
      end
    end
  end
end