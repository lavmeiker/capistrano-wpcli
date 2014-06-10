namespace :load do
  task :defaults do
    set :wp_roles, :all

    # You can pass parameters to WPCLI setting
    # env var WPCLI_ARGS on each run
    set :wpcli_args, ENV['WPCLI_ARGS']
  end
end

namespace :wpcli do
  desc "Runs a WP-CLI command"
  task :run, :command do |t, args|
    args.with_defaults(:command => :help)
    on release_roles(fetch(:wp_roles)) do
      within release_path do
        execute :wp, args[:command], fetch(:wpcli_args)
      end
    end
  end
end