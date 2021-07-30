# frozen_string_literal: true

require 'httparty'
require 'socket'
require 'etc'
require 'json'

class NetworkEvent
  def initialize
  end

  def connect
    destination_host = "http://www.google.com"
    destination_address = IPSocket::getaddress(destination_host)
    destination_port = 80
    source_address = Socket.ip_address_list.select(&:ipv4?).detect{|addr| addr.ip_address != '127.0.0.1'}.ip_address
    source_port = 8080
    payload = "hello"

    HTTParty.post(
      "http://#{destination_address}",
      local_port: source_port,
      local_host: source_address,
      body: payload
    )
    pid = Process.pid
    Process.setproctitle("network_event")

    name =  %x[ps -o comm -p #{pid}].split(' ')[1]
    command = %x[ps -o command -p #{pid}].split(' ')[1]

    {
      timestamp: Time.now,
      username: Etc.getpwuid(Process.uid).name,
      destination_address: destination_address,
      destination_port: destination_port,
      source_address: source_address,
      source_port: source_port,
      amount_of_data_sent: "#{payload.bytesize} bytes",
      protocol: 'http',
      process_id: pid,
      process_name: name,
      process_command: command
    }.to_json
  end
end
