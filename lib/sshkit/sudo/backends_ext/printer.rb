module SSHKit
  module Backend
    class Printer < Abstract
      def sudo(*args)
        command(:sudo, *args).tap do |cmd|
          output << cmd
        end
      end

      alias execute! execute
    end
  end
end
