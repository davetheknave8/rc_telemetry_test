# frozen_string_literal: true

require_relative 'file_event'
require_relative 'network_event'
require_relative 'process_event'

require 'securerandom'

@file_event = FileEvent.new(SecureRandom.uuid)
@network_event = NetworkEvent.new
@process_event = ProcessEvent.new

begin
  puts @file_event.create_file
  puts @file_event.modify_file
  puts @file_event.delete_file

  @network_event.connect

  @process_event.trigger_process
end
