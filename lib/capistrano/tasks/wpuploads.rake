namespace :load do
  task :defaults do
    # These options are passed directly to rsync
    # Append your options, overwriting the defaults may result in malfunction
    # Ex: --recursive --delete --exclude .git*
    set :wpcli_rsync_options, %w[-avz --rsh=ssh]

    # Local dir where WP stores the uploads
    # IMPORTANT: Add trailing slash!
    set :wpcli_local_uploads_dir, "web/app/uploads/"

    # Remote dir where WP stores the uploads
    # IMPORTANT: Add trailing slash!
    set :wpcli_remote_uploads_dir, -> {"#{shared_path.to_s}/web/app/uploads/"}
  end
end

namespace :wpcli do
  namespace :uploads do
    namespace :rsync do
      desc "Push local uploads delta to remote machine"
      task :push do
        roles(:web).each do |role|
          run_locally do
            execute :rsync, fetch(:wpcli_rsync_options), fetch(:wpcli_local_uploads_dir), "#{role.user}@#{role.hostname}:#{fetch(:wpcli_remote_uploads_dir)}"
          end
        end
      end

      desc "Pull remote uploads delta to local machine"
      task :pull do
        roles(:web).each do |role|
          run_locally do
            execute :rsync, fetch(:wpcli_rsync_options), "#{role.user}@#{role.hostname}:#{fetch(:wpcli_remote_uploads_dir)}", fetch(:wpcli_local_uploads_dir)
          end
        end
      end
    end
  end
end
