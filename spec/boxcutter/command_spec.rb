require 'spec_helper'
require 'stringio'

module Boxcutter
  describe Command do
    let(:logger) { StringIO.new }
    let(:remove_response) { stub(:body => "AW YEAH") }
    let(:machine) { stub("Machine", :remove! => remove_response, :hostname => 'app1') }
    let(:other_machine) { stub("Other Machine", :hostname => 'badapp2')}
    let(:machines) { [machine, other_machine] }
    let(:backends) { [backend, other_backend] }
    let(:other_backend) { stub("Other Backend", :name => 'foo')}
    let(:backend) { stub("Backend", :name => 'default', :machines => machines)}
    let(:app) { stub("App", :services => services) }
    let(:services) { [service] }
    let(:service) { stub("Service", :backends => backends) }

    subject { Command.new(logger) }

    def logger_contents
      logger.rewind
      logger.read
    end

    before(:each) do
      Boxcutter::LoadBalancer::Application.stub(:all).and_return([app])
    end

    describe "#remove_machine" do
      let(:hostname)    { "app1" }
      let(:backend_opt) { "default" }
      let(:dryrun)      { false }
      let(:opts) {{
        :backend => backend_opt,
        :dryrun  => dryrun,
        :hostname => hostname
      }}

      it "removes the machine from the load balancer" do
        machine.should_receive(:remove!)
        subject.remove_machine(opts)
      end

      it "logs when initializing" do
        subject.remove_machine(opts)

        logger_contents.should include("Removing app1 from default")
      end

      it "logs the raw response of the io" do
        subject.remove_machine(opts)

        logger_contents.should include("Response was: AW YEAH")
      end

      context "dry run" do
        let(:dryrun) { true }

        it "does not remove the machine" do
          machine.should_not_receive(:remove!)

          subject.remove_machine(opts)
        end

        it "logs the removal instead" do
          subject.remove_machine(opts)

          logger_contents.should include("app1 was not removed from the backend because --dryrun was specified")
        end
      end

      context "could not find a backend" do
        let(:backends) { [other_backend] }
  
        it "logs the error" do
          subject.remove_machine(opts)

          logger_contents.should include("Could not find 'default' backend")
        end
      end

      context "could not find a machine on the backend" do
        let(:machines) { [other_machine] }

        it "logs the error" do
          subject.remove_machine(opts)

          logger_contents.should include("Could not find 'app1' on 'default'")
        end
      end


      context "no hostname specified" do
        it "raises an IndexError" do
          expect do
            subject.remove_machine
          end.to raise_error(IndexError)
        end
      end
    end
  end
end
