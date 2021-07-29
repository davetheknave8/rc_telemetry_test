# frozen_string_literal: true

require 'etc'
require 'json'

class FileEvent
  attr_accessor :file_uuid

  def initialize(file_uuid)
    @file_name = "#{file_uuid}-testfile.txt"
  end

  def create_file
    pid = Process.fork do
      File.open(@file_name, "w") { |f| f.write("testing file creation") }
      Process.setproctitle("file_creation")
    end
    name =  %x[ps -o comm -p #{pid}].split(' ')[1]
    command = %x[ps -o command -p #{pid}].split(' ')[1]
    {
      timestamp: Time.now,
      username: Etc.getpwuid(Process.uid).name,
      descriptor: 'create_file',
      file_path: File.expand_path("./#{@file_name}"),
      process_id: pid,
      process_name: name,
      process_command: command
    }.to_json
  end

  def modify_file
    pid = Process.fork do
      File.open(@file_name, "a") { |f| f.write("testing file modification") }
      Process.setproctitle("file_modification")
    end
    name =  %x[ps -o comm -p #{pid}].split(' ')[1]
    command = %x[ps -o command -p #{pid}].split(' ')[1]
    {
      timestamp: Time.now,
      username: Etc.getpwuid(Process.uid).name,
      descriptor: 'modify_file',
      file_path: File.expand_path("./#{@file_name}"),
      process_id: pid,
      process_name: name,
      process_command: command
    }.to_json
  end

  def delete_file
    file_path = File.expand_path("./#{@file_name}")
    pid = Process.fork do
      file = File.delete(@file_name)
      Process.setproctitle("file_deletion")
    end
    name =  %x[ps -o comm -p #{pid}].split(' ')[1]
    command = %x[ps -o command -p #{pid}].split(' ')[1]
    {
      timestamp: Time.now,
      username: Etc.getpwuid(Process.uid).name,
      descriptor: 'delete_file',
      file_path: file_path,
      process_id: pid,
      process_name: name,
      process_command: command
    }.to_json
  end
end
