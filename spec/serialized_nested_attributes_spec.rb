require 'spec_helper'

describe SerializedNestedAttributes do
  context "show nested attributes" do
    it "raises an error if the nested attribute is not white listed" do
      Car = Class.new do
        extend SerializedNestedAttributes
        attr_accessor :details
        details_accessor :engine
        def initialize; @details = {}; end
      end

      car = Car.new
      car.details_attributes.should == [:engine]
    end
  end

  context "verify_valid_parent_attribute" do
    it "raises an error if parent attr is not valid" do
      expect{
        Course = Class.new do
          extend SerializedNestedAttributes
          details_accessor :instructor
          def initialize; @another_detail ={}; end
        end
      }.to raise_error(SerializedNestedAttributes::ParentAttrNotFound)
    end
  end

  context "vanilla class" do
    it "can extend accessor for serialized attributes" do
      Person = Class.new do
        extend SerializedNestedAttributes
        attr_accessor :details
        details_accessor :favorite_food, :favorite_musician
        def initialize; @details = {favorite_food: 'Sushi', favorite_musician: 'Bob Dylan'}; end
      end

      bob = Person.new
      bob.favorite_food.should == 'Sushi'
      bob.favorite_musician.should == 'Bob Dylan'
    end

    it "can extend writer for serialized attributes" do
      Person = Class.new do
        extend SerializedNestedAttributes
        attr_accessor :details
        details_writer :favorite_food
        def initialize; @details = Hash.new; end
      end

      katy = Person.new
      katy.details.should == {}
      katy.favorite_food = 'Pasta'
      katy.details[:favorite_food].should == 'Pasta'
      expect {katy.favorite_food}.to raise_error
    end

    it "can extend reader for serialized attributes" do
      Person = Class.new do
        extend SerializedNestedAttributes
        attr_accessor :details
        details_reader :favorite_musician
        def initialize; @details = {favorite_musician: 'Adele'}; end
      end

      david = Person.new
      david.favorite_musician.should == 'Adele'
      expect {david.favorite_musician = "Miley Cyrus"}.to raise_error
    end
  end

  context "ActiveRecord class" do
    before do
      ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
      ActiveRecord::Migration.create_table :products do |t|
        t.text :details
        t.timestamps
      end
    end

    after do
      # Clean up fake database migration
      ActiveRecord::Migration.drop_table :products
      # Clean up defined Product class
      Object.send(:remove_const, :Product)
    end

    it "can extend accessor for serialized attributes" do
      class Product < ActiveRecord::Base
        extend SerializedNestedAttributes
        serialize :details, Hash
        details_accessor :price
      end

      iphone = Product.create!(details: {price: 300})
      iphone.price.should == 300
    end

    it "can extend writer for serialized attributes" do
      class Product < ActiveRecord::Base
        extend SerializedNestedAttributes
        serialize :details, Hash
        details_writer :price
      end

      android_phone = Product.create!(details: {price: 300})
      android_phone.details[:price].should == 300
      expect {android_phone.price}.to raise_error
    end

    it "can extend reader for serialized attributes" do
      class Product < ActiveRecord::Base
        extend SerializedNestedAttributes
        serialize :details, Hash
        details_reader :price
      end

      windows_phone = Product.create!
      windows_phone.details[:price] = 300
      windows_phone.save!

      windows_phone.price.should == 300
      expect{window_phone.update_attributes!(price: 200)}.to raise_error
    end
  end
end
