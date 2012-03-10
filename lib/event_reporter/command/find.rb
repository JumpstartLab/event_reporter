module EventReporter
  module Command
    class Find
      def run(arguments)
        field = arguments[0]
        search_value = arguments[1]
        begin
          EventManager.instance.find(field.to_sym, search_value)
          "Searching for people with #{field} = #{search_value}\n"
        rescue EventManager::InvalidFieldError
          "Invalid search field. Please try again.\n"
        end

      end
    end
  end
end
