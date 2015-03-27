# SSHKit::Sudo

SSHKit extension, for sudo operation with password input.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sshkit-sudo'
```

And then execute:

    $ bundle

If you're using Capistrano, add the following to your Capfile:

```ruby
require 'sshkit/sudo'
```

## Usage

This gem adds `sudo`  and `execute!` command to SSHKit backends.

To execute a command with sudo, call `sudo` instead of `execute`.

```ruby
sudo :cp, '~/something', '/something'

# Or as follows:
execute! :sudo, :cp, '~/something', '/something'
```

### Examples in Capistrano tasks

```ruby
# Executing a command with sudo in Capistrano task
namespace :nginx do
  desc 'Reload nginx'
  task :reload do
    on roles(:web), in: :sequence do
      sudo :service, :nginx, :reload
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles(:web), in: :sequence do
      execute! :sudo, :service, :nginx, :restart
    end
  end
end

namespace :prov do
  desc 'Install nginx'
  task :nginx do
    on roles(:web), in: :sequence do

      within '/etc/apt' do
        unless test :grep, '-Fxq', '"deb http://nginx.org/packages/debian/ wheezy nginx"', 'sources.list'
          execute! :echo, '"deb http://nginx.org/packages/debian/ wheezy nginx"', '|', 'sudo tee -a sources.list'
          execute! :echo, '"deb-src http://nginx.org/packages/debian/ wheezy nginx"', '|', 'sudo tee -a sources.list'

          execute! :wget, '-q0 - http://nginx.org/keys/nginx_signing.key', '|', 'sudo apt-key add -'

          sudo :'apt-get', :update
        end
      end

      sudo :'apt-get', '-y install nginx'
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sshkit-sudo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
