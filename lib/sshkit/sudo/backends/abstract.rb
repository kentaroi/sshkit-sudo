module SSHKit
  module Sudo
    module Backend
      module Abstract
        def sudo(*args)
          execute!(:sudo, *args)
        end

        def execute!(*args)
          options = args.extract_options!
          options[:interaction_handler] ||= SSHKit::Sudo::InteractionHandler.new
          create_command_and_execute!(args, options).success?
        end

        private
        def execute_command!(*args)
          execute_command(*args)
        end

        def create_command_and_execute!(args, options)
          command(args, options).tap { |cmd| execute_command!(cmd) }
        end
      end
    end
  end
end
