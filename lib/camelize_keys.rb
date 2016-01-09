require 'camelize_keys/version'
require 'active_support/core_ext/string/inflections'

# Maps enumerables with keys to and from camelized and underscore
module CamelizeKeys
  autoload :EnumerableExtension, 'camelize_keys/enumerable_extension'
  autoload :ControllerExtension, 'camelize_keys/controller_extension'
  class CollisionError < StandardError; end

  def self.is_hashlike? enumerable
    enumerable.respond_to? :keys
  end

  def self.is_enumerablelike? item
    item.respond_to? :each
  end

  def self.is_stringlike? key
    key.is_a?(String) || key.is_a?(Symbol)
  end

  def self.transform_enumerable(enumerable, deep: false, raise_collision_errors: true, key_transformer:)
    if is_hashlike?(enumerable)
      enumerable.keys.each do |key|
        if is_stringlike? key
          new_key = key_transformer.call(key)
          new_key = new_key.to_sym if key.is_a? Symbol
          if new_key != key
            if raise_collision_errors && enumerable.has_key?(new_key)
              fail CollisionError, "Multiple values have mapped to #{new_key}, cannot complete transformation"
            end
            enumerable[new_key] = enumerable[key]
            enumerable.delete key
          end

          if deep && is_enumerablelike?(enumerable[new_key])
            transform_enumerable enumerable[new_key], deep: deep, key_transformer: key_transformer
          end
        end
      end
    elsif deep
      enumerable.each do |item|
        transform_enumerable(item, deep: deep, key_transformer: key_transformer) if is_enumerablelike?(item)
      end
    end

    enumerable
  end

  def self.camelize_keys enumerable, deep: false, raise_collision_errors: true
    transform_enumerable enumerable, deep: deep, key_transformer: (-> (key) { key.to_s.camelize(:lower) })
  end

  def self.underscore_keys enumerable, deep: false, raise_collision_errors: true
    transform_enumerable enumerable, deep: deep, key_transformer: (-> (key) { key.to_s.underscore })
  end
end
