require 'spec_helper'

describe SerializedNestedAttributes do
  it 'should be able to directly access nested attributes under a serialized attribute' do
    TestClass = Class.new do
      include SerializedNestedAttributes

      attr_accessor :details
      details_accessor :favorite_food

      def initialize
        @details = {favorite_food: 'Sushi'}
      end
    end

    test_object = TestClass.new
    test_object.favorite_food.should == "Sushi"
  end
end
