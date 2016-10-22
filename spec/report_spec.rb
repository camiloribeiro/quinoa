require File.dirname(__FILE__) + "/spec_helper"
require File.join(File.dirname(__FILE__), '../lib/quinoa/service.rb')

describe Quinoa do
  describe "The service should have an api that supports the" do

    before(:each) do 
      @service = Quinoa::Service.new "http://www.camiloribeiro.com"
    end

    it "reporting about the response" do
      stub_request(:any, "http://www.camiloribeiro.com").
        to_return(:status => 200, :body => "This request works fine")

      @service = Quinoa::Service.new "http://www.camiloribeiro.com"
      @service.get!

      expect(JSON.parse(@service.report).to_hash["health"]).to eq "health"
      expect(JSON.parse(@service.report).to_hash["response"]["status_code"]).to eq 200
      expect(JSON.parse(@service.report).to_hash["response"]["response_body"]).to eq "This request works fine"
      expect(JSON.parse(@service.report).to_hash["response"]["response_time"]).to be < 0.1

      expect(JSON.parse(@service.report).to_hash["assertions"]).to be {}
    end

    describe "execution of internao assertions" do

      it "for a check with success for status code" do
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request works fine")

        expect(@service.expectations).to eq Hash[]
        @service.add_expected_status 200

        @service.post!
        @service.check!

        expect(JSON.parse(@service.report).to_hash["health"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["response"]["status_code"]).to eq 200

        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["assertion_result"]).to eq true

      end

      it "for a check with success for body contains string" do
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request works fine")

        expect(@service.expectations).to eq Hash[]
        @service.add_expected_body_string "works"

        @service.post!
        @service.check!

        expect(JSON.parse(@service.report).to_hash["health"]).to eq "health"

        expect(JSON.parse(@service.report).to_hash["assertions"]["body"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["body"]["assertion_result"]).to eq true

      end

      it "for a check with success for response time under a threshold" do
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request works fine")

        expect(@service.expectations).to eq Hash[]
        @service.add_expected_max_response_time 1

        @service.post!
        @service.check!

        expect(JSON.parse(@service.report).to_hash["health"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["response"]["response_time"]).to be < 0.1

        expect(JSON.parse(@service.report).to_hash["assertions"]["response_time"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["response_time"]["assertion_result"]).to eq true

      end

      it "for a check with success for all checks" do
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request works fine")

        expect(@service.expectations).to eq Hash[]

        @service.add_expected_status 200
        @service.add_expected_body_string "works"
        @service.add_expected_max_response_time 1

        @service.post!
        @service.check!

        expect(JSON.parse(@service.report).to_hash["health"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["response"]["response_time"]).to be < 0.1

        expect(JSON.parse(@service.report).to_hash["assertions"]["response_time"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["response_time"]["assertion_result"]).to eq true

        expect(JSON.parse(@service.report).to_hash["assertions"]["body"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["body"]["assertion_result"]).to eq true

        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["status"]).to eq "health"
        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["assertion_result"]).to eq true
      end

      it "for a check with failure returning the right level" do
        stub_request(:any, "http://www.camiloribeiro.com").
          to_return(:status => 200, :body => "This request works fine")

        expect(@service.expectations).to eq Hash[]
        @service.add_expected_status 300

        @service.post!
        @service.check!

        expect(JSON.parse(@service.report).to_hash["health"]).to eq "fail"

        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["status"]).to eq "fail"
        expect(JSON.parse(@service.report).to_hash["assertions"]["status_code"]["assertion_result"]).to eq false

      end

    end
  end
end
