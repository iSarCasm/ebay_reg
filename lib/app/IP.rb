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
    puts "\n\nIP: #{ip}\n\n"
    try_to_change_IP
  end

  def ip
    sock_ip = Socket.ip_address_list.detect do |intf|
      intf.ipv4? and
      !intf.ipv4_loopback? and
      !intf.ipv4_multicast? and
      !intf.ipv4_private?
    end
    return sock_ip.ip_address if sock_ip
    return JSON.parse(%x[curl 'https://api.ipify.org?format=json'])["ip"]
  end

  protected

  def try_to_change_IP
    cmd = "cd /etc/openvpn/config && sudo openvpn --config \"#{@configs.sample}\""
    puts "#{cmd}"
    Kernel.spawn cmd
    sleep 10
  end
end
