require 'singleton'
require "csv"

class EventManager
  include Singleton
  HEADERS = "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS"
  OUTPUT_FIELDS = [:last_name, :first_name, :email_address, :zipcode, :city, :state, :street]

  # Public: Load a file into the manager
  #
  # Returns nothing
  # Raises Errno::ENOENT if the file cannot be found.
  def load_file(file_name)
    @file_contents = CSV.read(file_name, {:headers => true, :header_converters => :symbol})
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
  def find(field, value)
    @queue = @file_contents.find_all do |row|
      row[field] == value
    end
  end

  # Public: Print the current results in the queue
  def print_queue
    [HEADERS, format_queue(@queue)].join("\n")
  end

  private
  def format_row(row)
    row.fields(*OUTPUT_FIELDS).join("\t")
  end

  def format_queue(queue)
    queue.map{|row| format_row(row)}.join("\n")
  end

end
