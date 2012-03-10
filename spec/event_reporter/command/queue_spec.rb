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
  context "when a user wants to clear the queue" do
    it "tells the user that the queue is clear" do
      expected_output = "Queue cleared.\n"
      EventManager.instance.should_receive(:clear_queue)
      EventReporter::Command::Queue.new.run(['clear']).should == expected_output
    end
  end

  context "when a user wants to count the queue" do
    it "tells the user how many items are in the queue" do
      expected_output = "There are 6 items in the queue.\n"
      EventManager.instance.stub(:count_queue) { 6 }
      EventReporter::Command::Queue.new.run(['count']).should == expected_output
    end
  end

  context "for an unknown queue command" do
    it "tells the user" do
      expected_output = "Invalid command for the queue.\n"
      EventReporter::Command::Queue.new.run(['foo']).should == expected_output
    end
  end
end
