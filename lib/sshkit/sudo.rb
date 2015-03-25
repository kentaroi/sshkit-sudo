require "sshkit/sudo/version"
require "sshkit/sudo/backends_ext/printer"
require "sshkit/sudo/backends_ext/netssh"
require "sshkit/sudo/backends_ext/local"

module SSHKit
  module Sudo
    def self.password_cache
      @password_cache ||= {}
    end
  end
end
