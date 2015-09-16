# Capistrano::WPCLI

**Note: this plugin works only with Capistrano 3.**

Provides command line tools to facilitate Wordpress deploy.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-wpcli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-wpcli

## Usage

All you need to do is put the following in `Capfile` file:

    require 'capistrano/wpcli'

### How it works

The following tasks are added to Capistrano:

* `wpcli:run`<br/>
Executes the WP-CLI command passed as parameter.
Example: `cap production wpcli:run["core language install fr_FR"]`
* `wpcli:db:push`<br/>
Pushes the local WP database to the remote server and replaces the urls.<br/>
Use `backup_dir="/some/path"` argument to backup the remote database before push.<br/>
Example: `cap production wpcli:db:push backup_dir="."`
* `wpcli:db:pull`<br/>
Pulls the remote server WP database to local and replaces the urls.
* `wpcli:db:export`<br/>
Pulls the remote server WP database locally, uses `local_backup_directory` to define the location of the export.<br/>
Override export location with `backup="/some/path"` argument.
* `wpcli:rewrite:flush`<br/>
Flush rewrite rules.
* `wpcli:rewrite:hard_flush`<br/>
Perform a hard flush - update `.htaccess` rules as well as rewrite rules in database.
* `wpcli:uploads:rsync:push`<br/>
Push local uploads delta to remote machine using rsync.
* `wpcli:uploads:rsync:pull`<br/>
Pull remote uploads delta to local machine using rsync.

### Configuration

This plugin needs some configuration to work properly. You can put all your configs in Capistrano stage files i.e. `config/deploy/production.rb`.

Here's the list of options and the defaults for each option:

* `set :wpcli_remote_url`<br/>
Url of the Wordpress root installation on the remote server (used by search-replace command).

* `set :wpcli_local_url`<br/>
Url of the Wordpress root installation on the local server (used by search-replace command).

* `set :local_tmp_dir`<br/>
A local temp dir which is read and writeable. Defaults to `/tmp`.

* `set :local_backup_dir`<br/>
A local dir which is read and writeable. Defaults to `backup`.

* `set :wpcli_args`<br/>
You can pass arguments directly to WPCLI using this var. By default it will try to load values from `ENV['WPCLI_ARGS']`.

* `set :wpcli_local_uploads_dir`<br/>
Local dir where WP stores the uploads. IMPORTANT: Add trailing slash! Optional if using [Bedrock Wordpress Stack](http://roots.io/wordpress-stack/)

* `set :wpcli_remote_uploads_dir`<br/>
Remote dir where WP stores the uploads. IMPORTANT: Add trailing slash! Optional if using [Bedrock Wordpress Stack](http://roots.io/wordpress-stack/)

### Vagrant

If you are using another machine as a development server (Vagrant for example), you should define a `dev` role and indicate the path were the project lives on that server. This normally goes on `deploy.rb` file. Here's an example:

`server "example.dev", user: 'vagrant', password: 'vagrant', roles: %w{dev}`

`set :dev_path, '/srv/www/example.dev/current'`

## Contributing

1. Fork it ( https://github.com/lavmeiker/capistrano-wpcli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
