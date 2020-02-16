module CrystalInsideFort
  module ABSTRACT
    abstract class ViewEngine
      abstract def render(value : ViewEngineData) : Async(String)
    end
  end
end
