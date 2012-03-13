require 'spec_helper'
require_relative '../lib/event_manager'

def load_file
  sample_file_name = File.expand_path('../fixture_files/sample_event_attendees.csv', __FILE__)
  subject.load_file(sample_file_name)
end

describe EventManager do
  # Get around the singleton pattern here so you know that you
  # are working with a new EventManager object for each test.
  subject { EventManager.send(:new) }

  describe "loading a file" do
    it "erases any previously loaded searches" do
      load_file
      subject.find(:zipcode, '20010')
      # Assert that it found something in the search
      subject.print_queue.should match /20010/

      load_file
      # Assert that the search is gone.
      subject.print_queue.should_not match /20010/
    end

    it "pads all zipcodes to 5 characters" do
      load_file
      subject.find(:zipcode, '07306')
      # we should find one since there is one row in the
      # test data that was padded
      subject.print_queue.should match /07306/
    end

    it "sets missing zipcodes to 00000" do
      load_file
      subject.find(:zipcode, '00000')
      #  we should find one since there is one row in the
      #  test data that was missing
      subject.print_queue.should match /00000/
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
        load_file
        subject.find(:zipcode, '20010')
        subject.count_queue.should == 2
      end
    end
  end

  describe "clearing the queue" do
    it "removes all entries from the queue" do
      load_file
      subject.find(:zipcode, '20010')
      subject.count_queue.should == 2

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
      context "without a sorting criteria" do
        it "outputs headers and the results of the query" do
          load_file
          subject.find(:zipcode, '20010')

          expected_output = <<-__
LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS
Nguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW
Hankins\tSArah\tpinalevitsky@jumpstartlab.com\t20010\tWashington\tDC\t2022 15th Street NW
__

          subject.print_queue.should == expected_output.chomp
        end
      end
      context "with a sorting criteria" do
        it "outputs headers and sorts the results by the sorting criteria" do
          load_file
          subject.find(:zipcode, '20010')

          expected_output = <<-__
LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS
Hankins\tSArah\tpinalevitsky@jumpstartlab.com\t20010\tWashington\tDC\t2022 15th Street NW
Nguyen\tAllison\tarannon@jumpstartlab.com\t20010\tWashington\tDC\t3155 19th St NW
__

          subject.print_queue(:last_name).should == expected_output.chomp
        end
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
