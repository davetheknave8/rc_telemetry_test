# frozen_string_literal: true

class NetworkEvent
  def initialize
  end

  def connect
    addr = Socket.ip_address_list.select(&:ipv4?).detect{ |addr| addr.ip_address != '127.0.0.1' }.ip_address
    puts addr
  end
end
