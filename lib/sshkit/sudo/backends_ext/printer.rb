require 'sshkit'

module SSHKit
  module Backend
    class Printer < Abstract
      def sudo(*args)
        command(:sudo, *args).tap do |cmd|
          output << cmd
        end
      end
    end
  end
end
