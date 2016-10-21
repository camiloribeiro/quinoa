require "rest-client"
require "json"
require "benchmark"

module Quinoa
  class Service

    attr_accessor :url, :content_type, :accept, :body, :response, :path, :authorization, :custom_headers, :time, :insite_expectations


    def initialize url
      self.time = ""
      self.path = ""
      self.authorization = ""
      self.custom_headers = {}
      self.insite_expectations = {}
      self.url = url
    end

    def post! url=nil
      begin
        if url == nil
          self.time = Benchmark.measure do
            self.response = RestClient.post self.url + self.path, self.body, {:accept => self.accept, :content_type => self.content_type, :authorization => self.authorization}.merge!(self.custom_headers)
          end
        else
          self.time = Benchmark.measure do
            self.response = RestClient.post url, self.body, {:accept => self.accept, :content_type => self.content_type, :authorization => self.authorization}.merge!(self.custom_headers)
          end
        end
      rescue => e
        self.response = e.response
      end
    end

    def get! url=nil
      begin
        if url == nil
          self.time = Benchmark.measure do
            self.response = RestClient.get self.url + self.path, {:accept => self.accept, :authorization => self.authorization}.merge!(self.custom_headers)
          end
        else
          self.time = Benchmark.measure do
            self.response = RestClient.get url, {:accept => self.accept, :authorization => self.authorization}.merge!(self.custom_headers)
          end
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

    def remove_custom_header custom_header_name
      self.custom_headers.delete custom_header_name.to_sym
    end


    def report
      JSON.pretty_generate(
        {
          :health => true,
          :response => {
            :status_code => self.response.code,
            :response_body => self.response.body,
            :response_time => self.time.real
          }
        }
      )
    end

    def add_expected_status value
      add_expectation  "status_code", value, "eq", :fail
    end

    def add_expected_body_string value
      add_expectation  "body", value, "contains"
    end

    private
    def add_expectation attribute, value, comparison = "eq", level = :warn
      self.insite_expectations.merge! attribute.to_sym => {:compare_using => comparison, :value => value, :leval => level}
    end

  end
end
