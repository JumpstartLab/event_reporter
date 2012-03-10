require 'spec_helper'
require_relative '../../../lib/event_reporter/command/queue'

describe EventReporter::Command::Queue do
  context "when the user wants to print the queue" do
    it "prints out the results from the event manager" do
      expected_output = "Field1\tField2\nValue1\tValue2"
      EventManager.instance.stub(:print_queue) { expected_output }
      EventReporter::Command::Queue.new.run(['print']).should == expected_output
    end
  end
end
