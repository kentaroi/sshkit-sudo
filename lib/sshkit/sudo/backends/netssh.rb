module SSHKit
  module Sudo
    module Backend
      module Netssh
        private
        def execute_command!(cmd)
          output.log_command_start(cmd)
          cmd.started = true
          exit_status = nil
          with_ssh do |ssh|
            ssh.open_channel do |chan|
              chan.request_pty
              chan.exec cmd.to_command do |_ch, _success|
                chan.on_data do |ch, data|
                  cmd.on_stdout(ch, data)
                  output.log_command_data(cmd, :stdout, data)
                end
                chan.on_extended_data do |ch, _type, data|
                  cmd.on_stderr(ch, data)
                  output.log_command_data(cmd, :stderr, data)
                end
                chan.on_request("exit-status") do |_ch, data|
                  exit_status = data.read_long
                end
                #chan.on_request("exit-signal") do |ch, data|
                #  # TODO: This gets called if the program is killed by a signal
                #  # might also be a worthwhile thing to report
                #  exit_signal = data.read_string.to_i
                #  warn ">>> " + exit_signal.inspect
                #  output.log_command_killed(cmd, exit_signal)
                #end
                chan.on_open_failed do |_ch|
                  # TODO: What do do here?
                  # I think we should raise something
                end
                chan.on_process do |_ch|
                  # TODO: I don't know if this is useful
                end
                chan.on_eof do |_ch|
                  # TODO: chan sends EOF before the exit status has been
                  # writtend
                end
              end
              chan.wait
            end
            ssh.loop
          end
          # Set exit_status and log the result upon completion
          if exit_status
            cmd.exit_status = exit_status
            output.log_command_exit(cmd)
          end
        end
      end
    end
  end
end
