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

This gem adds `sudo` command to SSHKit backends.

To execute a command with sudo, call `sudo` instead of `execute`.

```ruby
# Executing a command with sudo in Capistrano task
desc 'hello'
task :hello do
  on roles(:all) do
    sudo :cp, '~/something', '/something'
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sshkit-sudo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
