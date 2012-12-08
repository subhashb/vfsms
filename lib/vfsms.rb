require "vfsms/version"
require "vfsms/config"
require 'net/http'
require 'uri'

=begin
initializer format
# Vfsms.config do |config|
#   config.username = useranme
#   config.password = password
#   config.url = url
# end
=end

module Vfsms
  def self.config(opts = {})
    @config ||= Vfsms::Config.new(opts)
    yield(@config) if block_given?
    @config
  end

  def self.send_sms(opts = {})
    @config ||= Vfsms.config(opts)
  
    message = opts[:message]
    from = opts[:from]
    send_to = opts[:send_to]

    return false, 'Phone Number is too short' if send_to.to_s.length < 10
    return false, 'Phone Number is too long' if send_to.to_s.length > 10
    return false, 'Phone Number should be numerical value' unless send_to.to_i.to_s == send_to.to_s
    return false, 'Message should be at least 10 characters long' if message.to_s.length < 11
    return false, 'Message should be less than 200 characters long' if message.to_s.length > 200

    opts[:username] = @config.username
    opts[:password] = @config.password
    opts[:url] = @config.url
    call_api(opts)
  end

  private

    def self.format_msg(opts = {})
      "<?xml version='1.0' encoding='ISO-8859-1'?>
      <!DOCTYPE MESSAGE SYSTEM 'http://127.0.0.1/psms/dtd/messagev12.dtd'>
      <MESSAGE VER='1.2'>
      <USER USERNAME='#{opts[:username]}' PASSWORD='#{opts[:password]}'/>
      <SMS UDH='0' CODING='1' TEXT='#{opts[:message]}' PROPERTY='0' ID='1'>
          <ADDRESS FROM='#{opts[:from]}' TO='#{opts[:send_to]}' SEQ='1' TAG='66,883'/>
      </SMS>
      </MESSAGE>"
    end

    def self.call_api(opts)
      params = {'data' => format_msg(opts), 'action' => 'send'}
      res = Net::HTTP.post_form(
        URI.parse(opts[:url]), 
        params
      )

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        if res.body.include?('GUID')
          return true, nil
        end
        return false, res.body
      else
        return false, "HTTP Error : #{res}"
      end
    end
end
