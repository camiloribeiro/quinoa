require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/quinoa/service.rb')

describe Quinoa do
  describe "The service should have the basic items of a service under test" do

    before(:each) do 
      @service = Quinoa::Service.new "http://www.camiloribeiro.com"
    end

    it "Should instanciate" do
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
end
