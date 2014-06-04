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

## Contributing

1. Fork it ( https://github.com/lavmeiker/capistrano-wpcli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
