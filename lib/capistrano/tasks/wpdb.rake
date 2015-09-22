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

    # A local backup dir which is read and writeable
    set :local_backup_dir, "backup"

    # Temporal db dumps path
    set :wpcli_remote_db_file, -> {"#{fetch(:tmp_dir)}/wpcli_database.sql.gz"}
    set :wpcli_local_db_file, -> {"#{fetch(:local_tmp_dir)}/wpcli_database.sql.gz"}
  end
end

namespace :wpcli do
  namespace :db do
    desc "Pull the remote database"
    task :pull do
      on roles(:web) do
        within release_path do
          execute :wp, :db, :export, "- |", :gzip, ">", fetch(:wpcli_remote_db_file)
          download! fetch(:wpcli_remote_db_file), fetch(:wpcli_local_db_file)
          execute :rm, fetch(:wpcli_remote_db_file)
        end
      end

      unless roles(:dev).empty?
        on roles(:dev) do
          within fetch(:dev_path) do
            upload! fetch(:wpcli_local_db_file), fetch(:wpcli_local_db_file)
            execute :gunzip, "<", fetch(:wpcli_local_db_file), "|", :wp, :db, :import, "-"
            execute :rm, fetch(:wpcli_local_db_file)
            execute :wp, "search-replace", fetch(:wpcli_remote_url), fetch(:wpcli_local_url), fetch(:wpcli_args) || "--skip-columns=guid", "--url=" + fetch(:wpcli_remote_url)
          end
        end
        run_locally do
          execute :rm, fetch(:wpcli_local_db_file)
        end
      else
        run_locally do
          execute :gunzip, "<", fetch(:wpcli_local_db_file), "|", :wp, :db, :import, "-"
          execute :rm, fetch(:wpcli_local_db_file)
          execute :wp, "search-replace", fetch(:wpcli_remote_url), fetch(:wpcli_local_url), fetch(:wpcli_args) || "--skip-columns=guid", "--url=" + fetch(:wpcli_remote_url)
        end
      end
    end

    desc "Push the local database"
    task :push do
      unless roles(:dev).empty?
        on roles(:dev) do
          within fetch(:dev_path) do
            execute :wp, :db, :export, "- |", :gzip, ">", fetch(:wpcli_local_db_file)
            download! fetch(:wpcli_local_db_file), fetch(:wpcli_local_db_file)
          end
        end
      else
        run_locally do
          execute :wp, :db, :export, "- |", :gzip, ">", fetch(:wpcli_local_db_file)
        end
      end
      on roles(:web) do
        upload! fetch(:wpcli_local_db_file), fetch(:wpcli_remote_db_file)
        within release_path do
          execute :gunzip, "<", fetch(:wpcli_remote_db_file), "|", :wp, :db, :import, "-"
          execute :rm, fetch(:wpcli_remote_db_file)
          execute :wp, "search-replace", fetch(:wpcli_local_url), fetch(:wpcli_remote_url), fetch(:wpcli_args) || "--skip-columns=guid", "--url=" + fetch(:wpcli_local_url)
        end
      end
      unless roles(:dev).empty?
        on roles(:dev) do
          within fetch(:dev_path) do
            execute :rm, fetch(:wpcli_local_db_file)
          end
        end
      end
      run_locally do
        execute :rm, fetch(:wpcli_local_db_file)
      end
    end

    desc "Export the remote database"
    task :export do
      on roles(:web) do
        within release_path do
          backup_dir = ENV["backup_dir"] || fetch(:local_backup_dir)
          execute :wp, :db, :export, "- |", :gzip, ">", fetch(:wpcli_remote_db_file)
          download! fetch(:wpcli_remote_db_file), backup_dir
        end
      end
    end

    before :push, :export if ENV["backup_dir"]
  end
end
