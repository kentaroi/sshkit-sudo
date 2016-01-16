require "sshkit/sudo/version"
require 'sshkit'
require 'sshkit/sudo/interaction_handler'
require 'sshkit/sudo/backends/abstract'
require 'sshkit/sudo/backends/netssh'

module SSHKit
  module Sudo
    def self.password_cache
      @password_cache ||= {}
    end
  end

  Backend::Abstract.send(:include, ::SSHKit::Sudo::Backend::Abstract)
  Backend::Netssh.send(:include, ::SSHKit::Sudo::Backend::Netssh)
end
