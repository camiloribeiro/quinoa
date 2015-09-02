require "rest-client"

module Quinoa
  class Service
    
    attr_accessor :url, :content_type, :accept, :body, :response
    
    def initialize url
      self.url = url
    end
    
    def post!
      begin
        self.response = RestClient.post self.url, self.body, :accept => self.accept, :content_type => self.content_type
      rescue => e
        self.response = e.response
      end
    end

    def get!
      begin
        self.response = RestClient.get self.url, :accept => self.accept
      rescue => e
        self.response = e.response
      end
    end


    def response_code
      self.response.code
    end

    def response_accept
      self.response.headers[:accept]
    end

    def response_content_type
      self.response.headers[:content_type]
    end

    def response_body
      self.response.body
    end

    def response_location
      self.response.headers[:location]
    end

  end
end
