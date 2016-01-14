require 'socket'

class IP
  def initialize(used_IPs, configs)
    @used_IPs = used_IPs
    @configs  = configs
    try_to_change_IP
  end

  def already_used?
    @used_IPs.include? ip
  end

  def change
    try_to_change_IP
  end

  def ip
    Socket.ip_address_list.detect do |intf|
      intf.ipv4? and
      !intf.ipv4_loopback? and
      !intf.ipv4_multicast? and
      !intf.ipv4_private?
    end.ip_address
  end

  protected

  def try_to_change_IP
    cmd = "sudo openvpn --config #{File.expand_path('../config/')}/#{@configs.sample}"
    puts "#{cmd}"
    %x[#{cmd}]
  end
end
