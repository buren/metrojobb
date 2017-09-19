require 'active_model'

module Metrojobb
  class Model
    include ActiveModel::Model

    InvalidError = Class.new(StandardError)

    def to_xml!
      return to_xml if valid?

      error_message = "#{model_name} has errors on: #{self.errors.keys.join(', ')}"
      raise(InvalidError, error_message)
    end
  end
end
