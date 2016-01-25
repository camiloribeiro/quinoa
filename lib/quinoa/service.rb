require "rest-client"

module Quinoa
  class Service

    attr_accessor :url, :content_type, :accept, :body, :response, :path, :authorization, :custom_headers

    def initialize url
      self.path = ""
      self.authorization = ""
      self.custom_headers = {}
      self.url = url
    end

    def post! url=nil
      begin
        if url == nil
          self.response = RestClient.post self.url + self.path, self.body, {:accept => self.accept, :content_type => self.content_type, :authorization => self.authorization}.merge!(self.custom_headers)
        else
          self.response = RestClient.post url, self.body, {:accept => self.accept, :content_type => self.content_type, :authorization => self.authorization}.merge!(self.custom_headers)
        end
      rescue => e
        self.response = e.response
      end
    end

    def get! url=nil
      begin
        if url == nil
          self.response = RestClient.get self.url + self.path, {:accept => self.accept, :authorization => self.authorization}.merge!(self.custom_headers)
        else
          self.response = RestClient.get url, {:accept => self.accept, :authorization => self.authorization}.merge!(self.custom_headers)
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

    def add_custom_header custom_header_name, custom_header_value 
      self.custom_headers.merge! custom_header_name.to_sym => custom_header_value.to_s
    end

  end
end
