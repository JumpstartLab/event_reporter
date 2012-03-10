require 'spec_helper'
require_relative '../lib/event_manager'

def load_file
  sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
  subject.load_file(sample_file_name)
end

def find_item
  load_file
  subject.find(:zipcode, '20010')
end

describe EventManager do
  # Get around the singleton pattern here so you know that you
  # are working with a new EventManager object for each test.
  subject { EventManager.send(:new) }

  describe "loading a file" do
    it "erases any previously loaded searches" do
      find_item
      # Assert that it found something in the search
      subject.print_queue.should match /20010/

      load_file
      # Assert that the search is gone.
      subject.print_queue.should_not match /20010/
    end
  end

  describe "counting the queue" do
    context "before a find is performed" do
      it "returns 0" do
        subject.count_queue.should == 0
      end
    end
    context "after a find is performed" do
      it "returns the number of items found in the search" do
        find_item
        subject.count_queue.should == 1
      end
    end
  end

  describe "clearing the queue" do
    it "removes all entries from the queue" do
      find_item
      subject.count_queue.should == 1

      subject.clear_queue

      subject.count_queue.should == 0
    end
  end

  describe "finding and printing queue" do
    context "before a file is loaded" do
      it "raises an EventManager::FileNotLoadedError" do
        expect { subject.find(:zipcode, '20010') }.to raise_error EventManager::FileNotLoadedError
      end

    end
    context "after a search" do
      it "outputs headers and the results of the query" do
        find_item

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\nNguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW"

        subject.print_queue.should == expected_output
      end
    end
    context "with an invalid search field" do
      it "raises a EventManager::InvalidFieldError" do
        load_file

        expect { subject.find(:foo, '20010') }.to raise_error EventManager::InvalidFieldError
      end
    end
    context "when called before a search is performed" do
      it "only prints out the headers" do
        load_file

        expected_output = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\n"

        subject.print_queue.should == expected_output
      end
    end
  end
end
