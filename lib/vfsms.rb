require "vfsms/version"

module Vfsms
  def initialize(opts)
    @api_url = opts[:api_url] || 'http://api.myvaluefirst.com/psms/servlet/psms.Eservice2'
    @api_params = {}
    @api_params[:username] = opts[:username]
    @api_params[:password] = opts[:password]
    @api_params[:version] = opts[:version] || '1.2'

    raise "Unsupported version" unless @api_params[:version] == '1.2'
  end

  def self.send_sms(opts = {})
    message = opts[:message]
    from = opts[:from]
    send_to = opts[:send_to]

    return false, 'Phone Number is too short' if send_to.to_s.length < 10
    return false, 'Phone Number is too long' if send_to.to_s.length > 10
    return false, 'Phone Number should be numerical value' unless send_to.to_i.to_s == send_to.to_s
    return false, 'Message should be at least 10 characters long' if message.to_s.length < 11
    return false, 'Message should be less than 200 characters long' if message.to_s.length > 200

    call_api(opts)
  end

  private

    def format_msg(opts = {})
      "<?xml version='1.0' encoding='ISO-8859-1'?>
      <!DOCTYPE MESSAGE SYSTEM 'http://127.0.0.1/psms/dtd/messagev12.dtd'>
      <MESSAGE VER='1.2'>
      <USER USERNAME='#{@api_params[:username]}' PASSWORD='#{@api_params[:password]}'/>
      <SMS UDH='0' CODING='1' TEXT='#{opts[:message]}' PROPERTY='0' ID='1'>
          <ADDRESS FROM='#{opts[:from]}' TO='#{opts[:send_to]}' SEQ='1' TAG='66,883'/>
      </SMS>
      </MESSAGE>"
    end

    def call_api(opts)
      params = {'data' => format_msg(opts), 'action' => 'send'}
      res = Net::HTTP.post_form(
        URI.parse(@api_url), 
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
