require 'active_support/concern'
module CamelizeKeys
  module EnumerableExtension
    extend ActiveSupport::Concern

    def camelize_keys! deep: false, raise_collision_errors: true
      CamelizeKeys.camelize_keys self, deep: deep, raise_collision_errors: raise_collision_errors
    end

    def underscore_keys! deep: false, raise_collision_errors: true
      CamelizeKeys.underscore_keys self, deep: deep, raise_collision_errors: raise_collision_errors
    end
  end
end
