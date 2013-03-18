require 'spec_helper'
require 'stringio'

module Boxcutter::LoadBalancer
  describe Backend do
    let(:logger)   { StringIO.new }
    let(:api)      { mock("Api", :machines => successful_response([{}, {}, {}])) }

    subject { Backend.new(api, {'id' => 123,
                                'backend_name' => 'test backend',
                                'port' => 80}, logger) }

    def logger_contents
      logger.rewind
      logger.read
    end

    describe "#each_machine_named" do
      let(:machine1) { mock("machine 1", :hostname => 'cool.machine')}
      let(:machine2) { mock("machine 2", :hostname => 'lame.machine')}
      let(:machine3) { mock("machine 3", :hostname => 'cool.machine')}
      let(:logger)   { StringIO.new }

      before(:each) do
        Machine.stub(:new).and_return(machine1, machine2, machine3)
      end

      it "looks up machines by id" do
        api.should_receive(:machines).with(123)
        subject.each_machine_named("whatever")
      end

      it "yields matching backends" do
        yielded = []
        subject.each_machine_named("cool.machine") {|b| yielded << b}
        yielded.should == [machine1, machine3]
      end

      context "unmatched name given" do
        it "yields nothing" do
          yielded = []
          subject.each_machine_named("bogus.machine") {|b| yielded << b}
          yielded.should == []
        end

        it "logs" do
          subject.each_machine_named("bogus.machine")

          logger_contents.should include("Could not find 'bogus.machine' on '#<Backend id:'123' name:'test backend'>")
        end
      end
    end
  end
end
