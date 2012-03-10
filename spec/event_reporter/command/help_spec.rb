require 'spec_helper'
require_relative '../../../lib/event_reporter/command/help'

describe EventReporter::Command::Help do
  it "lists the available commands" do
    expected_output = <<-__
exit - End the program.
help - Output a listing of the available individual commands.
help <command> - Display help for an individual command. For example: help find or help queue clear
load - Erase any loaded data and parse the specified file.
find - Find records that match a certain search criteria.
queue - Perform different actions on a queue loaded from a find command.
__
    EventReporter::Command::Help.new.run([]).should == expected_output
  end

  it "can list of help for a command that has one word" do
    expected_output = <<-__
Load the queue with all records matching the criteria for the given attribute. Example usages:

find zipcode 20011
find last_name Johnson
find state VA
    __
    EventReporter::Command::Help.new.run(['find']).should == expected_output
  end

  it "can list of help for a command that has two words" do
    expected_output = "Empty the queue.\n"
    EventReporter::Command::Help.new.run(['queue', 'clear']).should == expected_output
  end
end
