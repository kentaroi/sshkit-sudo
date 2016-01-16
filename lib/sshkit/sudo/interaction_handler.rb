module SSHKit
  module Sudo
    class DefaultInteractionHandler
      def wrong_password; self.class.wrong_password; end
      def password_prompt; self.class.password_prompt; end

      def on_data(command, stream_name, data, channel)
        if data =~ wrong_password
          puts data if defined?(Airbrussh) and
                       Airbrussh.configuration.command_output != :stdout and
                       data !~ password_prompt
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

      def password_cache_key(host)
        "#{host.user}@#{host.hostname}"
      end

      class << self
        def wrong_password
          @wrong_password ||= /Sorry.*\stry\sagain/
        end

        def password_prompt
          @password_prompt ||= /[Pp]assword.*:/
        end

        def wrong_password_regexp(regexp)
          @wrong_password = regexp
        end

        def password_prompt_regexp(regexp)
          @password_prompt = regexp
        end

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
