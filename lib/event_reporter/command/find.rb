module EventReporter
  module Command
    class Find
      def run(arguments)
        field = arguments[0]
        search_value = arguments[1]
        EventManager.instance.find(field.to_sym, search_value)
        "Searching for people with #{field} = #{search_value}\n"
      end
    end
  end
end
