# frozen_string_literal: true

require_relative 'file_event'
require_relative 'network_event'
require_relative 'process_event'

require 'securerandom'
require 'socket'

@file_event = FileEvent.new(SecureRandom.uuid)
@network_event = NetworkEvent.new
@process_event = ProcessEvent.new

begin
  log = []
  log << @file_event.create_file
  log << @file_event.modify_file
  log << @file_event.delete_file

  @network_event.connect

  @process_event.trigger_process
end
