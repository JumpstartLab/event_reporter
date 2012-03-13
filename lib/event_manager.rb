require 'singleton'
require "csv"

class EventManager

  class InvalidFieldError < StandardError
  end
  class FileNotLoadedError < StandardError
  end

  include Singleton
  HEADERS = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS"
  OUTPUT_FIELDS = [:last_name, :first_name, :email_address, :zipcode, :city, :state, :street]
  INVALID_ZIPCODE = '00000'

  def initialize
    @queue = []
  end

  # Public: Load a file into the manager and erases any loaded values.
  #
  # Returns nothing
  # Raises Errno::ENOENT if the file cannot be found.
  def load_file(file_name)
    @queue = []
    @file_contents = CSV.read(file_name, {:headers => true, :header_converters => :symbol})
    # not the most effective way since you will be iterating the file twice
    # If file loading starts to take a longer time then re-evaluate
    # this.
    format_zipcodes(@file_contents)
  end

  # Public: Load the queue with results that match the query.
  #
  # field  - A Symbol that determines what field to search
  # value - A string to match on.
  #
  # Examples
  #
  #   find(:zipcode, '80303')
  #
  # Returns nothing
  # Raises EventManager::InvalidFieldError if the search field is invalid
  # Raises EventManager::FileNotLoadedError if called before a file is loaded
  def find(field, value)
    raise EventManager::FileNotLoadedError if @file_contents.nil?
    raise EventManager::InvalidFieldError unless @file_contents.headers.include? field
    @queue = @file_contents.find_all do |row|
      row[field] == value
    end
  end

  # Public: Print the current results in the queue
  #
  # sort_columns  - A Symbol that determines what field to sort by. Defaults to nil
  #
  # Returns a string that represents what is in the queue with headers.
  def print_queue(sort_column = nil)
    [HEADERS, format_queue(sort_queue(@queue,sort_column))].join("\n")
  end

  # Public: Count the number of items in the queue
  #
  # Returns an integer that is the number of items in the queue
  def count_queue
    @queue.length
  end

  # Public: Remove all entries from the queue
  #
  # Returns nothing
  def clear_queue
    @queue.clear
  end

  private
  def format_row(row)
    row.fields(*OUTPUT_FIELDS).join("\t")
  end

  def format_queue(queue)
    queue.map { |row| format_row(row) }.join("\n")
  end

  def sort_queue(queue, sort_column)
    queue.sort do |row_one, row_two|
      row_one[sort_column] <=> row_two[sort_column]
    end
  end

  def format_zipcodes(csv_table)
    csv_table.each { |x| x[:zipcode] = clean_zipcode(x[:zipcode]) }
  end

  def clean_zipcode(dirty_zipcode)
    dirty_zipcode.nil? ? INVALID_ZIPCODE : dirty_zipcode.rjust(5, "0")
  end

end
