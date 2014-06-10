namespace :wpcli do
  namespace :rewrite do
    desc "Flush rewrite rules."
    task :flush do
      on roles(:web) do
        within release_path do
          execute :wp, :rewrite, :flush, fetch(:wpcli_args)
        end
      end
    end

    desc "Perform a hard flush - update `.htaccess` rules as well as rewrite rules in database."
    task :hard_flush do
      on roles(:web) do
        within release_path do
          execute :wp, :rewrite, :flush, "--hard", fetch(:wpcli_args)
        end
      end
    end
  end
end