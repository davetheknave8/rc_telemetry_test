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
        %x[#{@executable_file}]
        pid = Process.pid
        Process.setproctitle("process_event_executable_file_present")
    else
        1 + 1
        pid = Process.pid
        Process.setproctitle("process_event")
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
