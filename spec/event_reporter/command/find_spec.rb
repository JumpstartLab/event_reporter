require 'spec_helper'
require_relative '../../../lib/event_reporter/command/find'
require_relative '../../../lib/event_manager'


describe EventReporter::Command::Find do
  it "tells the user what they searched for" do
    EventReporter::Command::Find.new.run([:zipcode, "12345"]).should == "Searching for people with zipcode = 12345\n"
  end
  it "tells the EventManager to find the people with the proper arguments" do
    event_manager = double "event manager"
    event_manager.should_receive(:find).with(:zipcode, "12345")
    EventManager.stub(:instance) { event_manager }
    EventReporter::Command::Find.new.run(['zipcode', "12345"])
  end
end
