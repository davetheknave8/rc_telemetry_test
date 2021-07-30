# frozen_string_literal: true

require_relative 'file_event'
require_relative 'network_event'
require_relative 'process_event'

require 'securerandom'
require 'socket'
require 'byebug'
require 'fileutils'

PROCESS_ARG = ARGV[0]
FILE_PATH_ARG = ARGV[1]

@file_event = FileEvent.new(SecureRandom.uuid, FILE_PATH_ARG)
@network_event = NetworkEvent.new
@process_event = ProcessEvent.new(PROCESS_ARG)

begin
  log = []
  log << @file_event.create_file
  log << @file_event.modify_file
  log << @file_event.delete_file

  log << @network_event.connect

  log << @process_event.trigger_process

  puts log

  path = "logs/#{Time.now}_log.json"

  dir = File.dirname(path)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  File.open(path, "w") { |f| f.write(log) }
end
