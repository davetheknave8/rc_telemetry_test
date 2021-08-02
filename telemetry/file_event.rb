# frozen_string_literal: true

require 'etc'
require 'json'

class FileEvent
  attr_accessor :file_uuid

  def initialize(file_uuid, file_path)
    if file_path
      @file_name = "#{file_path}/#{file_uuid}-testfile.txt"
    else
      @file_name = "#{file_uuid}-testfile.txt"
    end
  end

  def create_file
    pid = Process.fork do
      File.open(@file_name, "w") { |f| f.write("testing file creation") }
      Process.setproctitle("file_creation")
    end
    file_path = File.expand_path("#{@file_name}")
    response(file_path, pid)
  end

  def modify_file
    pid = Process.fork do
      File.open(@file_name, "a") { |f| f.write("testing file modification") }
      Process.setproctitle("file_modification")
    end
    file_path = File.expand_path("#{@file_name}")
    response(file_path, pid)
  end

  def delete_file
    file_path = File.expand_path("#{@file_name}")
    pid = Process.fork do
      File.delete(@file_name)
      Process.setproctitle("file_deletion")
    end
    response(file_path, pid)
  end

  private def response(file_path, pid)
    {
      timestamp: Time.now,
      username: Etc.getpwuid(Process.uid).name,
      descriptor: 'delete_file',
      file_path: file_path,
      process_id: pid,
      process_name: process_name(pid),
      process_command: process_command(pid)
    }.to_json
  end

  private def process_name(pid)
    %x[ps -o comm -p #{pid}].split(' ')[1]
  end

  private def process_command(pid)
    %x[ps -o command -p #{pid}].split(' ')[1]
  end
end
