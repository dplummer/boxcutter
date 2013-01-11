require 'spec_helper'
require 'stringio'

module Boxcutter::LoadBalancer
  describe Service do
    let(:logger)   { StringIO.new }
    let(:api)      { mock("Api", :backends => [{}, {}, {}])}

    subject { Service.new(api, {'id' => 123, 'name' => 'test service', 'port' => 80}, logger) }

    def logger_contents
      logger.rewind
      logger.read
    end

    describe "#each_backend_named" do
      let(:backend1) { mock("Backend 1", :name => 'cool backend')}
      let(:backend2) { mock("Backend 2", :name => 'lame backend')}
      let(:backend3) { mock("Backend 3", :name => 'cool backend')}

      before(:each) do
        Backend.stub(:new).and_return(backend1, backend2, backend3)
      end

      it "looks up backends by id" do
        api.should_receive(:backends).with(123)
        subject.each_backend_named("whatever")
      end

      it "yields matching backends" do
        yielded = []
        subject.each_backend_named("cool backend") {|b| yielded << b}
        yielded.should == [backend1, backend3]
      end

      context "unmatched name given" do
        it "yields nothing" do
          yielded = []
          subject.each_backend_named("bogus backend") {|b| yielded << b}
          yielded.should == []
        end

        it "logs" do
          subject.each_backend_named("bogus backend")

          logger_contents.should include("Could not find 'bogus backend' on '#<Service id:'123' name:'test service' port:'80' service_type:''>")
        end
      end
    end
  end
end
