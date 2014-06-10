namespace :load do
  task :defaults do
    set :wp_roles, :all

    # You can pass global arguments directly to WPCLI using
    # this var
    set :wpcli_args, ''
  end
end

namespace :wpcli do
  desc "Runs a WP-CLI command"
  task :run, :command do |t, args|
    args.with_defaults(:command => :help)
    on release_roles(fetch(:wp_roles)) do
      within release_path do
        execute :wp, args[:command], *args.extras, fetch(:wpcli_args)
      end
    end
  end
end