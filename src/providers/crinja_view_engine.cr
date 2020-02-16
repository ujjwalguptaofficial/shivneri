require "crinja"

# require "../abstracts/index"

module CrystalInsideFort
  module PROVIDER
    class CrinjaViewEngine < ABSTRACT::ViewEngine
      def render(value : ViewEngineData)
        return Async(String).new (->{
          # view_data = get_view_from_file({
          #   file_location: value.view,
          # }).await
          view_data = get_view_from_file(ViewReadOption.new(value.view)).await
          # return Mustache.render(viewData, value.model);
          # return Crinja.render("Hello, {{ name }}!", {"name" => "John"}) # => "Hello, John!"
          return Crinja.render(view_data, value.model)
        })
      end
    end
  end
end
