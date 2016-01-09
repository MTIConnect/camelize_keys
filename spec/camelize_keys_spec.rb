require 'spec_helper'

describe CamelizeKeys do
  let(:deep) { true }

  let(:camelized_original) do
    {
      "foo" => "bar",
      "FuBar" => "blah",
      :binBaz => "BooBar",
      :subHash => {
        fooBarBinBaz: "blarg"
      }
    }
  end

  let(:underscore_original) do
    {
      "foo" => "bar",
      "fu_bar" => "blah",
      :bin_baz => "BooBar",
      :sub_hash => {
        foo_bar_bin_baz: "blarg"
      }
    }
  end
  it 'has a version number' do
    expect(CamelizeKeys::VERSION).not_to be nil
  end

  describe ".camelize_keys" do
    let(:result) { subject.camelize_keys(underscore_original, deep: deep) }
    it "transforms the hash to camelized format" do
      expect(result.keys).to match_array ["foo", "fuBar", :binBaz, :subHash]
    end

    it "transforms the subhash to camelized format" do
      expect(result[:subHash].keys).to match_array [:fooBarBinBaz]
    end

    context "when deep is false" do
      let(:deep) { false }
      it "transforms the hash to camelized format" do
        expect(result.keys).to match_array ["foo", "fuBar", :binBaz, :subHash]
      end

      it "does not transform the subhash to camelized format" do
        expect(result[:subHash].keys).to match_array [:foo_bar_bin_baz]
      end
    end

    context "given an array" do
      let(:result) { subject.camelize_keys([underscore_original], deep: deep) }
      it "transforms the hashes it contains" do
        expect(result.first.keys).to match_array ["foo", "fuBar", :binBaz, :subHash]
      end

      it "transforms subhashes" do
        expect(result.first[:subHash].keys).to match_array [:fooBarBinBaz]
      end

      context "when deep is false" do
        let(:deep) { false }
        it "does not alter hashes contained in the array" do
          expect(result.first.keys).to match_array ["foo", "fu_bar", :bin_baz, :sub_hash]
        end
      end
    end
  end

  describe ".underscore_keys" do
    let(:result) { subject.underscore_keys(camelized_original, deep: deep) }
    it "transforms the hash to camelized format" do
      expect(result.keys).to match_array ["foo", "fu_bar", :bin_baz, :sub_hash]
    end

    it "transforms the subhash to camelized format" do
      expect(result[:sub_hash].keys).to match_array [:foo_bar_bin_baz]
    end

    context "when deep is false" do
      let(:deep) { false }
      it "transforms the hash to camelized format" do
        expect(result.keys).to match_array ["foo", "fu_bar", :bin_baz, :sub_hash]
      end

      it "does not transform the subhash to camelized format" do
        expect(result[:sub_hash].keys).to match_array [:fooBarBinBaz]
      end
    end

    context "given an array" do
      let(:result) { subject.underscore_keys([camelized_original], deep: deep) }
      it "transforms the hashes it contains" do
        expect(result.first.keys).to match_array ["foo", "fu_bar", :bin_baz, :sub_hash]
      end

      it "transforms subhashes" do
        expect(result.first[:sub_hash].keys).to match_array [:foo_bar_bin_baz]
      end

      context "when deep is false" do
        let(:deep) { false }
        it "does not alter hashes contained in the array" do

          expect(result.first.keys).to match_array ["foo", "FuBar", :binBaz, :subHash]
        end
      end
    end

    context "when multiple values would map to the same new value" do
      it "raises an error" do
        expect do
          subject.underscore_keys({ 'fooBar' => 1, 'FooBar' => 2 })
        end.to raise_error CamelizeKeys::CollisionError
      end

      context "given raise collision errors disabled" do
        it "does not raise an error" do
          expect do
            subject.underscore_keys({ 'fooBar' => 1, 'FooBar' => 2 }, raise_collision_errors: false)
          end.to raise_error CamelizeKeys::CollisionError
        end
      end
    end
  end
end
