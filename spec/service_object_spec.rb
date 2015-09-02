require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/quinoa/service.rb')

describe Quinoa do
  describe "The service should have the basic items of a service under test" do

    before(:each) do 
      @service = Quinoa::Service.new "http://www.camiloribeiro.com"
    end

    it "Should instantiate" do
      expect(@service.url).to eq "http://www.camiloribeiro.com"
    end
    
    it "Should have a Content-Type" do
      expect(@service.content_type).to eq nil
      
      @service.content_type = "application/json"
      expect(@service.content_type).to eq "application/json"
    end
    
    it "Should have a Accept" do
      expect(@service.accept).to eq nil
      
      @service.accept = "application/xml;q=0.9,*/*;q=0.8."
      expect(@service.accept).to eq "application/xml;q=0.9,*/*;q=0.8."
    end
    
    it "Should have a body" do
      expect(@service.body).to eq nil
      
      @service.body = "text"
      expect(@service.body).to eq "text"
    end

  end

  describe "the service should have the basic behaviours of a service" do

    before(:each) do 
      stub_request(:any, "http://www.camiloribeiro.com/").
        to_return(:status => 200, :body => "simple response", :headers => {:accept=>"application/xml", :content_type => "application/json"})

      @service = Quinoa::Service.new "http://www.camiloribeiro.com"
      @service.content_type = "application/json"
      @service.body = "simple body"

    end

    it "should post" do
      @service.post!
      
      # explicity
      expect(@service.response.headers[:accept]).to eq("application/xml")
      expect(@service.response.headers[:content_type]).to eq("application/json")
      expect(@service.response.body).to eq("simple response")
      expect(@service.response.code).to eq(200)

      # natural
      expect(@service.response_accept).to eq("application/xml")
      expect(@service.response_content_type).to eq("application/json")
      expect(@service.response_body).to eq("simple response")
      expect(@service.response_code).to eq(200)
    end

    it "should get" do
      @service.get!

      # explicity
      expect(@service.response.headers[:accept]).to eq("application/xml")
      expect(@service.response.headers[:content_type]).to eq("application/json")
      expect(@service.response.body).to eq("simple response")
      expect(@service.response.code).to eq(200)

      # natural
      expect(@service.response_accept).to eq("application/xml")
      expect(@service.response_content_type).to eq("application/json")
      expect(@service.response_body).to eq("simple response")
      expect(@service.response_code).to eq(200)
    end

  end
end
