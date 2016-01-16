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

### Configuration
Available in sshkit-sudo 0.1.0 and later.

#### Same password across servers
If you are using a same password across all servers, you can skip inputting the password for the second server or after
by using `use_same_password!` method in your `deploy.rb` as follows:
```ruby
class SSHKit::Sudo::InteractionHandler
  use_same_password!
end
```

#### Password prompt and wrong password matchers
You can set your own matchers in your `deploy.rb` as follows:
```ruby
class SSHKit::Sudo::InteractionHandler
  password_prompt_regexp /[Pp]assword.*:/
  wrong_password_regexp /Sorry.*\stry\sagain/
end
```

#### Making your own handler
You can write your own handler in your `deploy.rb` as follows:
```ruby
class SSHKit::Sudo::InteractionHandler
  def on_data(command, stream_name, data, channel)
    if data =~ wrong_password
      SSHKit::Sudo.password_cache[password_cache_key(command.host)] = nil
    end
    if data =~ password_prompt
      key = password_cache_key(command.host)
      pass = SSHKit::Sudo.password_cache[key]
      unless pass
        print data
        pass = $stdin.noecho(&:gets)
        puts ''
        SSHKit::Sudo.password_cache[key] = pass
      end
      channel.send_data(pass)
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
