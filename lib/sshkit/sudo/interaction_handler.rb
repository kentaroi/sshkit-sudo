module SSHKit
  module Sudo
    class DefaultInteractionHandler
      def on_data(command, stream_name, data, channel)
        if data =~ /Sorry.*\stry\sagain/
          SSHKit::Sudo.password_cache[password_cache_key(command.host)] = nil
        end
        if data =~ /[Pp]assword.*:/
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

      def password_cache_key(host)
        "#{host.user}@#{host.hostname}"
      end

      class << self
        def use_same_password!
          class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def password_cache_key(host)
            '0'
          end
          METHOD
        end
      end
    end

    class InteractionHandler < DefaultInteractionHandler
    end
  end
end
