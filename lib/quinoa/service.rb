require "rest-client"
require "json"
require "benchmark"
require "rspec"

module Quinoa
  class Service

    attr_accessor :url, :content_type, :accept, :body, :response, :path, :authorization, :custom_headers, :time, :expectations, :assertions

    def initialize url
      self.time = ""
      self.path = ""
      self.authorization = ""
      self.custom_headers = {}
      self.expectations = {}
      self.assertions = {}
      self.url = url
    end

    def put! url=nil
      p_methods("put", url)
    end

    def post! url=nil
      p_methods("post", url)
    end

    def get! url=nil
      begin
        if url == nil
          get_time {
            RestClient.get(
              self.url + self.path,
              {:accept => self.accept,
               :authorization => self.authorization}.merge!(self.custom_headers)
            )
          }
        else
          get_time {
            RestClient.get(
              url,
              {:accept => self.accept,
               :authorization => self.authorization}.merge!(self.custom_headers)
            )
          }
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
          :health => get_health(self.assertions.map{|a| a[1][:status]}),
          :response => {
            :status_code => self.response.code,
            :response_body => self.response.body,
            :response_time => self.time.real
          },
          :assertions => self.assertions
        }
      )
    end

    def check!
      #TO DO: Handle case when response is nil
      exit 0 if self.response.nil?
      self.expectations.each do | expectation |
        assertion_item = expectation[0]
        expectation_map = Hash[*expectation][assertion_item]

        self.assertions.merge! get_assertion_record(
          assertion_item,
          expectation_map[:value],
          check_attribute?(
            assertion_item,
            expectation_map[:value],
            expectation_map[:compare_using]),
          expectation_map[:level])
      end
    end

    def add_expected_status value
      add_expectation  "status_code", value, "eq", :fail
    end

    def add_expected_body_string value
      add_expectation  "body", value, "contains"
    end

    def add_expected_max_response_time value
      add_expectation  "response_time", value, "under"
    end

    private
    def p_methods method_name, url=nil
      meth = RestClient.method(method_name)
      begin
        if url == nil
          get_time {
            meth.call(
              self.url + self.path,
              self.body,
              {:accept => self.accept,
               :content_type => self.content_type,
               :authorization => self.authorization}.merge!(self.custom_headers)
            )
          }
        else
          get_time {
            meth.call(
              url,
              self.body,
              {:accept => self.accept,
               :content_type => self.content_type,
               :authorization => self.authorization}.merge!(self.custom_headers)
            )
          }
        end
      rescue => e
        self.response = e.response
      end
    end


    def add_expectation attribute, value, comparison = "eq", level = :warn
      self.expectations.merge! attribute.to_sym => {:compare_using => comparison, :value => value, :level => level}
    end

    def check_attribute? attribute, expected_value, comparator
      value = self.response.code if attribute == :status_code
      value = self.response.body if attribute == :body
      value = self.time.real if attribute == :response_time

      return value == expected_value if (comparator == "eq")
      return value.include? expected_value if (comparator == "contains")
      return value < expected_value if (comparator == "under")

    end

    def get_assertion_record assertion_item, expected_value, assertion_result, level
      {
        assertion_item => {
          :status => get_status(assertion_result, level),
          :expected_value => expected_value,
          :assertion_result => assertion_result,
        }
      }
    end

    def get_status assertion_result, level
      return level if !assertion_result
      return :health
    end

    def get_health all_health_status
      return :fail   if all_health_status.include? :fail
      return :warn   if all_health_status.include? :warn
      return :health if all_health_status.include? :health
      return "health"
    end

    def get_time
      self.time = Benchmark.measure do
        self.response = yield
      end
    end

  end
end
