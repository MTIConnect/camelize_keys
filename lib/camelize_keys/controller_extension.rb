require 'active_support/concern'

module CamelizeKeys
  module ControllerExtension
    extend ActiveSupport::Concern

    included do
      before_action do
        CamelizeKeys.underscore_keys params, deep: true
      end

      rescue_from CamelizeKeys::CollisionError do |e|
        render "public/400", :status => 400
      end
    end
  end
end
