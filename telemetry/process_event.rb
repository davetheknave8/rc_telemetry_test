# frozen_string_literal: true

require 'json'
require 'etc'

class ProcessEvent
  attr_accessor :process_arg

  def initialize(process_arg)
    @executable_file = process_arg
  end

  def trigger_process
    time_started = Time.now
    if @executable_file
      pid = Process.fork do
        %x[#{@executable_file}]
        Process.setproctitle("process_event_executable_file_present")
      end
    else
      pid = Process.fork do
        1 + 1
        Process.setproctitle("process_event")
      end
    end

    name = %x[ps -o comm -p #{pid}].split(' ')[1]
    command = %x[ps -o command -p #{pid}].split(' ')[1]

    {
      timestamp: time_started,
      username: Etc.getpwuid(Process.uid).name,
      process_name: name,
      process_command: command,
      process_id: pid
    }.to_json
  end
end
