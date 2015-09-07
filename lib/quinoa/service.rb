require "rest-client"

module Quinoa
  class Service

    attr_accessor :url, :content_type, :accept, :body, :response, :path, :authorization

    def initialize url
      self.path = ""
      self.authorization = ""
      self.url = url
    end

    def post! url=nil
      begin
        if url == nil
          self.response = RestClient.post self.url + self.path, self.body, :accept => self.accept, :content_type => self.content_type, :authorization => self.authorization
        else
          self.response = RestClient.post url, self.body, :accept => self.accept, :content_type => self.content_type, :authorization => self.authorization
        end
      rescue => e
        self.response = e.response
      end
    end

    def get! url=nil
      begin
        if url == nil
          self.response = RestClient.get self.url + self.path, :accept => self.accept, :authorization => self.authorization
        else
          self.response = RestClient.get url, :accept => self.accept, :authorization => self.authorization
        end
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
