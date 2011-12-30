module Vfsms
  class Config
    attr_accessor :username, :password, :url
    
    def initialize(opts)
      @url = opts[:api_url] || 'http://api.myvaluefirst.com/psms/servlet/psms.Eservice2'
      @username = opts[:username] || 'strataxml'
      @password = opts[:password] || 'strata2010xml'
      @api_params = {}
      @api_params[:version] = opts[:version] || '1.2'

      raise "Unsupported version" unless @api_params[:version] == '1.2'
    end
  end
end