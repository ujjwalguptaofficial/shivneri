module CrystalInsideFort
  module MODEL
    class ViewEngineData(T)
      getter view, model
      ##
      # name of the view or path of view
      #
      # @type {string}
      #
      view : String ##
      # view models
      #
      # @type {#}
      #
      #    model : any;

      def initialize(@view : String, @model : T)
      end
    end
  end
end
