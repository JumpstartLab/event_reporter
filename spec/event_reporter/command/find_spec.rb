require 'spec_helper'
require_relative '../../../lib/event_reporter/command/find'
require_relative '../../../lib/event_manager'


describe EventReporter::Command::Find do
  context "for a valid search field" do
    it "tells the user what they searched for" do
      EventManager.instance.stub(:find).with(:zipcode, "12345")
      EventReporter::Command::Find.new.run([:zipcode, "12345"]).should == "Searching for people with zipcode = 12345\n"
    end
    it "tells the EventManager to find the people with the proper arguments" do
      EventManager.instance.should_receive(:find).with(:zipcode, "12345")
      EventReporter::Command::Find.new.run(['zipcode', "12345"])
    end
  end
  context "for an invalid search field" do
    it "tells the user that the field is invalid" do
      EventManager.instance.stub(:find).with(:foo, "12345").and_raise EventManager::InvalidFieldError
      EventReporter::Command::Find.new.run(['foo', "12345"]).should == "Invalid search field. Please try again.\n"
    end
  end

  context "when a file is not loaded" do
    it "tells the user that the file is not loaded" do
      EventManager.instance.stub(:find).with(:foo, "12345").and_raise EventManager::FileNotLoadedError
      EventReporter::Command::Find.new.run(['foo', "12345"]).should == "File is not loaded. Please run load command.\n"
    end
  end

end
