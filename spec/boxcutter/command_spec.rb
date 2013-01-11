require 'spec_helper'
require 'stringio'

module Boxcutter
  describe Command do
    let(:logger) { StringIO.new }
    let(:remove_response) { stub(:body => "AW YEAH") }
    let(:add_response) { stub(:body => "YEEUH") }
    let(:machine) { stub("Machine",
                         :remove!     => remove_response,
                         :hostname => 'app1',
                         :id => "MACHINE1",
                         :to_s => 'app1 machine') }
    let(:found_backends) { [backend] }
    let(:found_machines) { [machine] }
    let(:backend) { stub("Backend",
                         :name => 'default',
                         :add_server => add_response,
                         :to_s => 'default')}
    let(:app) { stub("App", :services => services) }
    let(:services) { [service] }
    let(:service) { stub("Service", :name => "HTTP", :to_s => 'HTTP') }

    subject { Command.new(logger) }

    def logger_contents
      logger.rewind
      logger.read
    end

    before(:each) do
      Boxcutter::LoadBalancer::Application.stub(:all).and_return([app])
      service.stub(:each_backend_named).and_yield(backend)
      backend.stub(:each_machine_named).and_yield(machine)
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

        logger_contents.should include("Removing app1 machine from default")
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

      context "no hostname specified" do
        it "raises an IndexError" do
          expect do
            subject.remove_machine
          end.to raise_error(IndexError)
        end
      end
    end

    describe "#add_machine" do
      let(:hostname)    { "app1" }
      let(:backend_opt) { "default" }
      let(:dryrun)      { false }
      let(:opts) {{
        :backend => backend_opt,
        :dryrun  => dryrun,
        :hostname => hostname
      }}
      let(:server) { stub("Server", :hostname => 'app1', :id => "APP1") }

      before(:each) do
        Boxcutter::Server.stub(:find_by_hostname).
                          with("app1.blueboxgrid.com").
                          and_return(server)
      end

      it "logs the server add" do
        subject.add_machine(opts)

        logger_contents.should include("Adding server app1 to backend default")
      end

      it "adds the machine by id, using port 80" do
        backend.should_receive(:add_server).with('APP1', :port => 80)
        subject.add_machine(opts)
      end

      it "logs the server add" do
        subject.add_machine(opts)

        logger_contents.should include("Adding server app1 to backend default")
      end

      context "dry run" do
        let(:dryrun) { true }

        it "does not add the server to the backend" do
          backend.should_not_receive(:add_server)
          subject.add_machine(opts)
        end

        it "instead logs the add" do
          subject.add_machine(opts)

          logger_contents.should include("app1 was not added to the backend because --dryrun was specified")
        end
      end
    end
  end
end
