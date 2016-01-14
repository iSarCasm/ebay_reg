require 'mechanize'
require 'json'
require 'singleton'
require 'faker'
require 'logger'
require_relative 'app/ebay_api'
require_relative 'app/IP'
require_relative 'app/account'
require_relative 'app/user'

class EbatEbay
  include Singleton

  def initialize
    @IP_list     = JSON.parse(File.read(File.expand_path('../../db/ip', __FILE__)))
    @CONFIG_list = JSON.parse(File.read(File.expand_path('../../db/configs', __FILE__)))
    @EMAIL_list  = JSON.parse(File.read(File.expand_path('../../db/email', __FILE__)))
  end

  def run
    retrieve_IP
    @account = EbayAPI.sign_up(generate_user)
    save
  end

  protected

  def save
    @EMAIL_list.delete(@email)
    @IP_list.push(@ip.ip)

    File.open(File.expand_path('../../db/ip', __FILE__), 'w') do |f|
      f.write(@IP_list.to_json)
    end

    File.open(File.expand_path('../../db/email', __FILE__), 'w') do |f|
      f.write(@EMAIL_list.to_json)
    end

    accounts = JSON.parse(File.read((File.expand_path('../../db/ebay_accounts', __FILE__))))
    accounts.push @account.to_h
    File.open(File.expand_path('../../db/ebay_accounts', __FILE__), 'w') do |f|
      f.write(accounts.to_json)
    end
  end

  def retrieve_IP
    @ip = IP.new(@IP_list, @CONFIG_list)
    loop do
      puts @ip.ip
      if @ip.already_used?
        @ip.change
      else
        break
      end
      sleep 1
    end
  end

  def generate_user
    User.new(random_email)
  end

  def random_email
    @email = @EMAIL_list.sample
  end
end
