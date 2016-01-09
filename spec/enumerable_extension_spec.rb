require 'spec_helper'
require 'camelize_keys/ext/hash'
require 'camelize_keys/ext/array'

describe CamelizeKeys::EnumerableExtension do
  it "extends array to transform itself" do
    array = [{ foo_bar: 'Foo' }]
    array.camelize_keys! deep: true
    expect(array.first.keys).to match_array [:fooBar]
    array.underscore_keys! deep: true
    expect(array.first.keys).to match_array [:foo_bar]
  end

  it "extens hash to transform itself" do
    hash = { foo_bar: 'Foo' }
    hash.camelize_keys!
    expect(hash.keys).to match_array [:fooBar]
    hash.underscore_keys!
    expect(hash.keys).to match_array [:foo_bar]
  end
end
