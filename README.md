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

This gem adds a `:pty_handler` option to commands.

To execute a command with interactive sudo add the `:pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO` option.

```ruby
execute :sudo, :cp, '~/something', '/something', :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
```

### Examples in Capistrano tasks

```ruby
# Executing a command with sudo in Capistrano task
namespace :nginx do
  desc 'Reload nginx'
  task :reload do
    on roles(:web), in: :sequence do
      execute :sudo, :service, :nginx, :reload, :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles(:web), in: :sequence do
      execute :sudo, :service, :nginx, :restart, :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
    end
  end
end

namespace :prov do
  desc 'Install nginx'
  task :nginx do
    on roles(:web), in: :sequence do

      within '/etc/apt' do
        unless test :grep, '-Fxq', '"deb http://nginx.org/packages/debian/ wheezy nginx"', 'sources.list'
          execute :echo, '"deb http://nginx.org/packages/debian/ wheezy nginx"', '|', 'sudo tee -a sources.list', :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
          execute :echo, '"deb-src http://nginx.org/packages/debian/ wheezy nginx"', '|', 'sudo tee -a sources.list', :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO

          execute :wget, '-q0 - http://nginx.org/keys/nginx_signing.key', '|', 'sudo apt-key add -', :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO

          sudo :sudo, 'apt-get', :update, :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
        end
      end

      execute :sudo, :'apt-get', '-y install nginx', :pty_handler => SSHKit::Sudo::INTERACTIVE_SUDO
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
