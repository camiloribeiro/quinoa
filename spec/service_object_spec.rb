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

    it "Should have a authorizoation" do
      expect(@service.content_type).to eq nil

      @service.authorization = "token !#€%&/()="
      expect(@service.authorization).to eq "token !#€%&/()="
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
 
    describe "Custom headers" do

      it "Should be able to add a single custom header" do

        expect(@service.custom_headers).to eq Hash[]

        @service.add_custom_header "my-company-custom-header", "text"
        expect(@service.custom_headers).to eq Hash[:"my-company-custom-header" => "text"]
      end

      it "Should be able to add many custom headers" do
        expect(@service.custom_headers).to eq Hash[]

        @service.add_custom_header "my-company-custom-header", "text"
        @service.add_custom_header "headerx", "bar"
        @service.add_custom_header :"my-foo-custom-header", "foo"

        expect(@service.custom_headers).to eq Hash[:"my-company-custom-header" => "text", :headerx => "bar", :"my-foo-custom-header" => "foo"]
      end

      ["post", "get"].each do |method|
      it "Should be present in the #{method} requests" do
        # For this mock order matters
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request requires a 'my-company-custom-header' to work")

        stub_request(:any, "http://www.camiloribeiro.com").
          with(:headers => { 'my-company-custom-header' => "text" }).
          to_return(:status => 200, :body => "This request works fine")

        @other_service = Quinoa::Service.new "http://www.camiloribeiro.com"

        expect(@service.custom_headers).to eq Hash[]
        expect(@other_service.custom_headers).to eq Hash[]

        @service.add_custom_header "my-company-custom-header", "text"
        @service.add_custom_header "headerx", "bar"
        @service.add_custom_header :"my-foo-custom-header", "foo"

        expect(@service.custom_headers).to eq Hash[:"my-company-custom-header" => "text", :headerx => "bar", :"my-foo-custom-header" => "foo"]
        expect(@other_service.custom_headers).to eq Hash[]

        @service.send "#{method}!"
        @other_service.send "#{method}!"

        expect(@service.response.body).to eq("This request works fine")
        expect(@other_service.response.body).to eq("This request requires a 'my-company-custom-header' to work")
      end
    end
    end
  end

  describe "overwiting the entire url to post and get" do

      before(:each) do 
        stub_request(:any, "http://www.bugbang.com.br/foo").
          to_return(:status => 200, :body => "simple response", :headers => {:accept=>"application/xml", :content_type => "application/json"})

        @service = Quinoa::Service.new "http://www.camiloribeiro.com"
        @service.path = "/something"
        @service.content_type = "application/json"
        @service.authorization = "token !#€%&/()="
        @service.body = "simple body"

      end

      it "should overwite for get" do
          @service.get! "http://www.bugbang.com.br/foo"

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response.code).to eq(200)
      end

      it "should overwite for post" do
          @service.post! "http://www.bugbang.com.br/foo"

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response.code).to eq(200)
      end
  end


  describe "defining a different paths" do

    ["/", "/path"].each do |path|
      describe "should work for the path #{path}" do
    
        before(:each) do 
          stub_request(:any, "http://www.camiloribeiro.com#{path}").
            to_return(:status => 200, :body => "simple response", :headers => {:accept=>"application/xml", :content_type => "application/json"})

          @service = Quinoa::Service.new "http://www.camiloribeiro.com"
          @service.path = path
          @service.content_type = "application/json"
          @service.authorization = "token !#€%&/()="
          @service.body = "simple body"

        end

        it "should post" do
          @service.post!

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response.code).to eq(200)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response_code).to eq(200)
        end

        it "should get" do
          @service.get!

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response.code).to eq(200)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("simple response")
          expect(@service.authorization).to eq "token !#€%&/()="
          expect(@service.response_code).to eq(200)
        end

        
      end
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

    # 303 post and get, 301 get, 302 get and 307 get failing
    [301,302,307].each do |code|
      describe "when returning code #{code}" do
        before(:each) do 
          stub_request(:any, "http://www.camiloribeiro.com/").
            to_return(:status => code, :body => "simple response", :headers => {:accept=>"application/xml", :content_type => "application/json", :location => "http://www.bugbang.com.br"})

          stub_request(:any, "http://www.bugbang.com.br/").
            to_return(:status => 200, :body => "followed redirect", :headers => {:accept=>"application/xml", :content_type => "application/json"})

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
          expect(@service.response.headers[:location]).to eq("http://www.bugbang.com.br")
          expect(@service.response.code).to eq(code)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("simple response")
          expect(@service.response_location).to eq("http://www.bugbang.com.br")
          expect(@service.response_code).to eq(code)
        end

        it "should get" do

          @service.get!

          # explicity
          expect(@service.response.headers[:accept]).to eq("application/xml")
          expect(@service.response.headers[:content_type]).to eq("application/json")
          expect(@service.response.body).to eq("followed redirect")
          expect(@service.response.code).to eq(200)

          # natural
          expect(@service.response_accept).to eq("application/xml")
          expect(@service.response_content_type).to eq("application/json")
          expect(@service.response_body).to eq("followed redirect")
          expect(@service.response_code).to eq(200)
        end

      end
    end
  end
end
