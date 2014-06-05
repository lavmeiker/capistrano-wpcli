namespace :load do
  task :defaults do
    # The url under which the wordpress installation is
    # available on the remote server
    set :wpcli_remote_url, "http://example.com"

    # The url under which the wordpress installation is
    # available on the local server
    set :wpcli_local_url, "http://example.dev"

    # A local temp dir which is read and writeable
    set :local_tmp_dir, "/tmp"
    
    # Temporal db dumps path
    set :wpcli_remote_db_file, "#{fetch(:tmp_dir)}/wpcli_database.sql"
    set :wpcli_local_db_file, "#{fetch(:local_tmp_dir)}/wpcli_database.sql"
  end
end

namespace :wpcli do
  namespace :db do
    desc "Pull the remote database"
    task :pull do
      on roles(:web) do
        within release_path do
          execute :wp, "db export",  fetch(:wpcli_remote_db_file)
          download! fetch(:wpcli_remote_db_file), fetch(:wpcli_local_db_file)
          execute :rm, fetch(:wpcli_remote_db_file)
        end

        run_locally do
          execute :wp, "db import", fetch(:wpcli_local_db_file)
          execute :rm, "#{fetch(:wpcli_local_db_file)}"
          execute :wp, "search-replace", "'#{fetch(:wpcli_remote_url)}' '#{fetch(:wpcli_local_url)}' --skip-columns=guid"
        end
      end
    end

    desc "Push the local database"
    task :push do
      on roles(:web) do
        run_locally do
          execute :wp, "db export", fetch(:wpcli_local_db_file)
        end

        upload! fetch(:wpcli_local_db_file), fetch(:wpcli_remote_db_file)

        run_locally do
          execute :rm, fetch(:wpcli_local_db_file)
        end

        within release_path do
          execute :wp, "db import", fetch(:wpcli_remote_db_file)
          execute :rm, fetch(:wpcli_remote_db_file)
          execute :wp, "search-replace", "'#{fetch(:wpcli_local_url)}' '#{fetch(:wpcli_remote_url)}' --skip-columns=guid"
        end
      end
    end
  end
end