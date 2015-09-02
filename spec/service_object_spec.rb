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

    # 303 post and get, 301 get, 302 get and 307 get failing
    [100,101,102,200,201,202,203,204,205,206,207,208,226,300,304,305,306,308,308,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,420,421,422,423,424,426,428,429,431,440,444,449,450,451,451,494,495,496,497,498,499,499,500,501,502,503,504,505,506,507,508,509,510,511,520,522,598,599].each do |code|
      describe "when returning code #{code}" do
        before(:each) do 
          stub_request(:any, "http://www.camiloribeiro.com/").
            to_return(:status => code, :body => "simple response", :headers => {:accept=>"application/xml", :content_type => "application/json"})

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
          expect(@service.response.code).to eq(code)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("simple response")
          expect(@service.response_code).to eq(code)
        end

        it "should get" do
          @service.get!

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("simple response")
          expect(@service.response.code).to eq(code)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("simple response")
          expect(@service.response_code).to eq(code)
        end

      end
    end
  end
end
