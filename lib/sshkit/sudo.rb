require "sshkit/sudo/version"
require 'sshkit'
require "sshkit/sudo/backends_ext/netssh"

module SSHKit
  module Sudo
    INTERACTIVE_SUDO = lambda do |data, ch, cmd|
      if data =~ /Sorry.*\stry\sagain/
        password_cache[password_cache_key(cmd.host)] = nil
      end
      if data =~ /password.*:/
        key = password_cache_key(cmd.host)
        pass = password_cache[key]
        unless pass
          pass = $stdin.noecho(&:gets)
          password_cache[key] = pass
        end
        ch.send_data(pass)
      end
    end

    def self.password_cache_key(host)
      "#{host.user}@#{host.hostname}"
    end

    def self.password_cache
      @password_cache ||= {}
    end
  end
end
