#!/usr/bin/env ruby
require "csv"

# Reopening `Hash` to inject custom methods
class Hash
  # Prints a `Hash` instance to be printed on screen.
  def cli_print_format
    self.map{|key, value|  "#{Helpers.green(key)}\n #{value}"}.join("\n") + "\n"
  end
end

# Reopening `Array` to inject custom methods
class Array

  # Converts an array of Hashes into a CSV string compliant to the `EventReporter` output.
  # Note that this code is very specific to this use case and I wouldn't do that in a larger project.
  # Or if this code was to be used in a library.
  #
  # @return [String] CSV compliant string
  def to_csv_string
    # We shouldn't rely on the hash order event tho it's a Ruby 1.9 feature
    CSV.generate do |csv|
      # add headers
      csv << EventReporter::CSV_ATTRIBUTES
      self.each do |row|
        csv << row.values_at(*EventReporter::CSV_ATTRIBUTES) if row.respond_to?(:values_at)
      end
    end
  end

  # Compares the integer value of each item of an array
  # and returns an array containing the bigger cast value.
  # Note: kinda crazysauce, do not use in prod!
  # @param [Array] The array to compare against
  # @return [Array<Integer>]
  def bigger_integer_values(other_array)
    raise ArgumentError unless other_array.is_a?(Array)
    output = Array.new(self.length)
    converter = lambda{|v| v.is_a?(Fixnum) ? v : v.to_s.length}
    each_with_index do |item, idx|
      a, b = converter.call(item), converter.call(other_array[idx])
      output[idx] = a > b ? a : b
    end
    output
  end
end

module Kernel

  # Prints a string in a paginated way based on the return carriage.
  # The user is required to press enter to keep scrolling through the results.
  # @param [String] text The text to print.
  # @param [Fixnum] max_lines The amount of lines to print at once.
  def print_paged(text, max_lines=10)
    lines = text.split("\n")
    nbr_slices = (lines.length / max_lines.to_f).ceil
    i = 0
    lines.each_slice(max_lines) do |slice|
      print slice.join("\n") + "\n"
      i += 1
      if i < nbr_slices
        print Helpers.gray("Press <enter> to paginate through the result of the results.")
        while pressed = gets.chomp
          if pressed == "" || pressed == " "
            break
          else
            print Helpers.read("I said <enter> not #{pressed}!\n")
          end
        end
      end
    end
  end
end

# Various helpers "packaged" in a module.
module Helpers
  # Zipcode to use instead of an invalid/bad zipcode
  INVALID_ZIPCODE = "00000"

  # Colorizes a string to be printed on screen using ANSI codes.
  # @see http://en.wikipedia.org/wiki/ANSI_escape_code
  #
  # @param [String] The string to colorize.
  # @param [String] ANSI escape code.
  # @return [String] colorized string.
  def self.colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end

  # Formats the passed string to be printed in red on screen
  # @param [String] text The text to colorize.
  # @return [String]
  def self.red(text); colorize(text, "\e[31m"); end

  # Formats the passed string to be printed in green on screen
  # @param [String] text The text to colorize.
  # @return [String]
  def self.green(text); colorize(text, "\e[32m"); end

  # Formats the passed string to be printed in gray on screen
  # @param [String] text The text to colorize.
  # @return [String]
  def self.gray(text); colorize(text, "\e[37m"); end

  # Formats the passed string to be printed boldon screen
  # @param [String] text The text to colorize.
  # @return [String]
  def self.bold(text); colorize(text, "\e[1m"); end

  # Standardizes passed zipcode strings.
  # @param [String] zipcode The string to normalize
  # @return [String] standardized zipcode string
  def self.clean_zipcode(zipcode)
    zipcode.nil? ? INVALID_ZIPCODE : zipcode.rjust(5, "0")
  end

  # Formats a row/record in a way that can be nicely printed on screen
  # @param [Hash] row_hash A queue row to format
  # @param [NilClass, Array] col_width A optional array with the width of each column
  # @return [String] The formatted string version of the passed param.
  def self.print_row_format(row_hash, col_widths=nil)
    col_widths ||= []
    output = Array.new(row_hash.keys.length)
    EventReporter::PRINT_ATTRIBUTES_ORDER.each_with_index do |attr, idx|
      output[idx] = row_hash[attr].ljust(col_widths[idx] || 0, " ")
    end
    output.join("\t")
  end

  # Formats a queue in a way that can be nicely printed to screen
  # @param [Array] queue The queue to print, An array of Hash instances matching the csv format is expected.
  # @return [String] The output ready to be printed to screen
  def self.queue_print_format(queue)
    output = []
    return red("The queue is currently empty.\n") if queue.empty?
    col_widths = max_widths_for_queue(queue)
    headers = []
    EventReporter::PRINT_HEADERS.each_with_index do |h, idx| 
      headers << h.ljust(col_widths[idx], " ")
    end
    output << green(headers.join("\t"))
    output += queue.map{|row| Helpers.print_row_format(row, col_widths)}
    output.join("\n") + "\n"
  end

  # Calculates the max width of each column
  # by looking at the longest value.
  # @param [Array] queue The queue to inspect.
  # @return [Array] Array of the max values in the queue format
  def self.max_widths_for_queue(queue)
    sizes = Array.new(row_sorted_print_values(queue.first).size, 0)
    # I could have loaded all the variables in memory and use #max each array representing
    # the values as shown below. But it wouldn't have been fun and it would have required
    # to create a copy of all the objects in memory so I decided to go the more complex/fun way.
    # While I had fun, the code is complicated and hard to justify, don't do that in prod ;)
    # What I should have done:
    #   EventReporter::PRINT_ATTRIBUTES_ORDER.map do |attr|
    #     queue.map{|r| r[attr].to_s.size}.max
    #   end
    # What I did instead:
    queue.each do |row|
      sizes = row_sorted_print_values(row).bigger_integer_values(sizes)
    end
    sizes
  end

  # Returns the print values for a given row
  # @param [Hash] The row to extract the values from.
  # @return [Array]
  def self.row_sorted_print_values(row)
    row.values_at(*EventReporter::PRINT_ATTRIBUTES_ORDER)
  end

end

# This class allows us to load and process a CSV file.
# One can search the content of the file, sort the results, print or save them to another file
# via a virtual "queue"
class EventReporter

  # Default CSV file used as a default.
  DEFAULT_CSV = "event_attendees.csv"
  # Arguments that are available when calling the queue command.
  VALID_QUEUE_ARGS = %W{count clear print save}
  # Headers used to print and save the filtered results.
  PRINT_HEADERS = ['LAST NAME', 'FIRST NAME', 'EMAIL', 'ZIPCODE', 'CITY', 'STATE', 'ADDRESS']
  # sorted methods available on each record/row.
  PRINT_ATTRIBUTES_ORDER = [:last_name, :first_name, :email_address, :zipcode, :city, :state, :street]
  # Expected CSV attributes
  CSV_ATTRIBUTES = [:_, :regdate, :first_name, :last_name, :email_address, :homephone, :street, :city, :state, :zipcode]

  # Creates a new instance of the reporter.
  # In not mentioned otherwise, the file defined in the `DEFAULT_CSV` constant
  # is loaded.
  # @param [String] path The path to a CSV file compliant with the expected format (see `PRINT_ATTRIBUTES_ORDER`).
  # @raise [Errno::ENOENT] if the passed path doesn't exist or not of a valid type.
  # @param [String] file
  def initialize(path=nil)
    path ||= DEFAULT_CSV
    print "loading and parsing #{path}\n"
    @content = CSV.read(path, {:headers => true, :header_converters => :symbol})
    @queue = []
  end

  # Searches the existing queue and find all instances where the given attribute matches
  # the passed criteria.
  # Results are stored in the queue and not printed right away, but an indication of the amount
  # of matching results is returned.
  # @param [String, Symbol] attribute The attribute to apply the search on.
  # @param [String] criteria the exact match we are looking for (case insensitive).
  # @return [String] An indication about the amount of matches found in the queue.
  def find_all(attribute, criteria)
    if PRINT_ATTRIBUTES_ORDER.include?(attribute.to_sym)
      @queue.clear
      results = []
      @content.each do |row|
        looked_up_value = row[attribute.to_sym]
        next unless looked_up_value
        if looked_up_value.downcase == criteria.downcase
          match = Hash[@content.headers.zip(row.fields)]
          match[:zipcode] = Helpers.clean_zipcode(match[:zipcode])
          results << match
        end
      end
      @queue += results unless results.empty?
      "#{results.length} results found.\n"
    else
      Helpers.red("Can't search by #{attribute}, try one of the following: #{PRINT_ATTRIBUTES_ORDER.join(', ')}.\n")
    end
  end

  # Processes the queue based on the passed command.
  # See `VALID_QUEUE_ARGS` for the available queue commands or even better check the help.
  # @param [String] cmd Queue command to execute.
  # @param [NilClass, Array] args Extra arguments to be used with the print command.
  # @return [String] The result of the queue command.
  def queue(cmd, args=nil)
    case cmd
    when 'count'
      "#{@queue.length} records are in the current queue.\n"
    when 'clear'
      @queue.clear
      "Queue was emptied.\n"
    when 'print'
      if args.nil? || args.empty?
        Helpers.queue_print_format(@queue)
      elsif args[0] == 'by' && args[1]
        sorted_queue_print_format_by(args[1].to_sym)
      else
        Helpers.red("Unknown queue print command, see the help for more info.\n")
      end
    when 'save'
      if args.nil? || args.empty? || args[0] != 'to' || !args[1]
        return Helpers.red("Please check the help to see how to use the `queue save to` command.\n")
      else
        save_queue_as_csv_to(args[1])
      end
    else
      return Helpers.red("Unknown queue arguments: #{args}, only #{VALID_QUEUE_ARGS.join(', ')} are supported.\n")
    end
  end

  ### Meant for internal consumption only ###
  
  # Saves the current queue as a csv file.
  # @param [String] Path to the file to save.
  # @return [String] Status message describing the status of the file being saved.
  def save_queue_as_csv_to(path)
    path = File.expand_path(path)
    print "Attempting to save the current queue to #{path}\n"
    begin
      File.open(path, 'wb'){|f| f << @queue.to_csv_string }
    rescue Errno::ENOENT => e
      Helpers.red("Error trying to save the queue, check the destination location. #{e.message}\n")
    else
      "Queue exported.\n"
    end
  end


  # Sorts a queue and format it for print
  # @see Helpers#queue_print_format
  # @param [Symbol] attr The attribute to sort by the queue before printing it.
  # @return [String] The output ready to be printed to screen.
  def sorted_queue_print_format_by(attr)
    if PRINT_ATTRIBUTES_ORDER.include?(attr)
      Helpers.queue_print_format(@queue.sort_by{|item| item[attr]})
    else
      Helpers.red("Unknown queue sorting attribute: #{attr}, try one of the following: #{PRINT_ATTRIBUTES_ORDER.join(', ')}.\n")
    end
  end

end

# Module designed to provide some indications to the end user.
module CLIHelp

  # Lists the commands returned as a Hash, the keys being the commands and the values being the descriptions.
  # @return [Hash]
  def self.commands
    @commands ||= { 
  'load <filename>' => 'Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv.',
  'help <command>'  => "Output a description of how to use the specific command. For example:
   help queue clear
   help find",
  'help' => 'Output a listing of the available individual commands',
  'queue count' => 'Output how many records are in the current queue',
  'queue clear' => 'Empty the queue', 
  'queue print' => "Print out a tab-delimited data table with a header row following this format:
  LAST NAME  FIRST NAME  EMAIL  ZIPCODE  CITY  STATE  ADDRESS", 
  'queue print by <attribute>' => 'Print the data table sorted by the specified attribute like zipcode.', 
  'queue save to <filename.csv>' => 'Export the current queue to the specified filename as a CSV.', 
  'find <attribute> <criteria>' => "Load the queue with all records matching the criteria for the given attribute. Example usages:
  * find zipcode 20011
  * find last_name Johnson
  * find state VA",
  'exit' => "Exit this program",
  'reload' => "Reload this program"}
  end

  # Returns help for a given command or for a command close to what is passed.
  # @param [String] cmd The command we want to print the help for.
  # @return [String] The appropriate help information.
  def self.for(cmd)
    return full_help if cmd.nil? || cmd == 'help' || cmd.empty?
    # find the matching command by removing the user input arguments
    cmd_key = commands.keys.find{|c| c.gsub(/<.*/, '').strip == cmd.strip}
    return " #{Helpers.green(cmd_key)}\n#{commands[cmd_key]}\n" if cmd_key
    # find partial matches in the command list to help the user
    cmds = commands.keys.find_all{|c| c.gsub(/<.*/, '').strip =~ /#{cmd.strip}/i}
    if cmds.empty?
      Helpers.red("Unknown command: `#{cmd}`, try one of the following commands:\n#{full_help}")
    else
      commands.reject{|c| !cmds.include?(c) }.cli_print_format
    end
  end

  # Lists all the available commands.
  # @return [String]
  def self.full_help
    commands.cli_print_format
  end
end

# Wrapper module used to interface the command line interface with the "backend"/reporter.
module CLIController

  @reporter = nil

  # Creates a new instance of `EventReporter` loading the optionally passed path.
  # @param [String] path The path to the csv file to load.
  # @return [String] Status message describing potential issues or if the reporter is ready.
  def self.load(path=nil)
    begin
      @reporter = EventReporter.new(path)
    rescue Errno::ENOENT
      Helpers.red("There was a problem opening #{path}.\n")
    else
      "Event reporter ready to be searched.\n"
    end
  end

  # Sends a command to the reporter's queue if the reporter was set.
  # An error message is returned if the reporter wasn't set.
  #
  # @param [String] arg Can be count, clear or print, see CLIHelp for more details
  #   about each command
  # @param [NilClass, Array] extra Extra arguments sent with the queue command.
  def self.queue(arg, *extra)
    with_reporter_set do
      @reporter.queue(arg, extra)
    end
  end

  # Looks for matching records in the reporter's memory and add the results to the queue.
  # Note that staring a new research clears the existing queue.
  # @see EventReporter#find_all
  # @param [String] attribute The attribute to search for.
  # @param [String] criteria The value we expect to match during the search.
  # @return [String] An error message or a search result info.
  def self.find(attribute=nil, criteria=nil)
    with_reporter_set do
      if attribute.nil? || criteria.nil?
        Helpers.red("maformed request, you need to call `find <attribute> <criteria>`\n")
      else
        @reporter.find_all(attribute, criteria)
      end
    end
  end

  # Exists the current application and print a goodbye message.
  def self.exit
    print Helpers.bold("Ciao!\n")
    Kernel.exit
  end

  # Reloads this code to more easily test/develop without quitting the app.
  def self.reload
    print Helpers.red("Reloading, warnings about already initialized constants are exected.\n")
    Kernel.load(File.expand_path(__FILE__))
  end

  # Method taking a block which gets yield if a reporter was set.
  # If the reporter wasn't set, an error message is returned.
  # @return [String] The output of the passed block or an error message.
  def self.with_reporter_set
    if @reporter
      yield if block_given?
    else
      "load a file before looking for a record\n"
    end
  end

end

# Print a nice message before exiting
trap("INT") { print "Thanks for visiting, come again!\n"; exit }

# setting the TEST env variable skips the loop
# so the code can be loaded in IRB or in a test suite without blocking
# the run loop.
# Example:
#     $ TEST=1 irb -r./event_reporter
unless ENV['TEST']
  #################  Loop used to capture the user's input  ####################
  print Helpers.bold("Welcome to EventReporter, what you would like to do today?\n\
  Type `help` for more info on the available commands.\n")
  while command = gets.chomp
    args = command.split(/\s+/)
    cmd = args[0] || ''
    if !cmd.empty? && CLIController.respond_to?(cmd)
      print Helpers.green(" > #{command}\n")
      print_paged CLIController.send(cmd, *args[1..-1])
    else
      print Helpers.green(" > #{command}\n")
      print_paged CLIHelp.for(command.gsub(/^help\s+/, ''))
    end
    print Helpers.gray("----\n")
  end
end
