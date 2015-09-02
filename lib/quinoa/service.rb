module Quinoa
  class Service
    attr_accessor :url, :content_type, :accept, :body
    def initialize url
      self.url = url
    end
  end
end
