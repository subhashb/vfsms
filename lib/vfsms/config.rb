module Vfsms
  class Config
    attr_accessor :username, :password, :url
    
    def initialize(opts)
      @api_params = {}
      @api_params[:version] = opts[:version] || '1.2'

      raise "Unsupported version" unless @api_params[:version] == '1.2'
    end
  end
end