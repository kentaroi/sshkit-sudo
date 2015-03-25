require 'sshkit'

module SSHKit
  module Backend
    class Local < Printer
      def sudo(*args)
        _execute(:sudo, *args).success?
      end
    end
  end
end
