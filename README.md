# Capistrano::WPCLI

**Note: this plugin works only with Capistrano 3.**

Simple Capistrano wrapper using WP-CLI

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
* `wpcli:db:push`<br/>
Pushes the local WP database to the remote server and replaces the urls.
* `wpcli:db:pull`<br/>
Pulls the remote server WP database to local and replaces the urls.

### Configuration

This plugin needs some configuration to work properly. You can put all your configs in capistrano stage files i.e. `config/deploy/production.rb`.

Here's the list of options and the defaults for each option:

* `set :wpcli_remote_url`<br/>
Url of the Wordpress root installation on the remote server (used by search-replace command).

* `set :wpcli_local_url`<br/>
Url of the Wordpress root installation on the local server (used by search-replace command).

* `set :local_tmp_dir`<br/>
A local temp dir which is read and writeable. Defaults to `/tmp`.

## Contributing

1. Fork it ( https://github.com/lavmeiker/capistrano-wpcli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
