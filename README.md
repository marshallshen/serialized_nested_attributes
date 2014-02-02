# SerializedNestedAttributes

A clean interface to access nested fields under a serialized attribute

## Usage
Following Ruby's convention, we defined *accessor (readers and writers)*, *reader*, and *writer*

### Accessor
```ruby
class Person < ActiveRecord::Base
  serialize :details, Hash
  details_accessor :favorite_food, :favorite_musician
end

tom = Person.first
tom.details # => {:favorite_food => "Sushi", :favorite_musician => "Bob Dylan"}

tom.favorite_food # => "Sushi"
tom.favorite_musician
```

### Writer
```ruby
class Person < ActiveRecord::Base
  serialize :details, Hash
  details_writer :favorite_food, :favorite_musician
end

tom = Person.new(details: {:favorite_food => "Sushi", :favorite_musician => "Bob Dylan"})
tom.details # => {:favorite_food => "Sushi", :favorite_musician => "Bob Dylan"}

tom.favorite_food # raise error!
tom.details[:favorite_food] # => "Sushi"
```

### Reader
```ruby
class Person < ActiveRecord::Base
  serialize :details, Hash
  details_reader :favorite_food, :favorite_musician
end

tom = Person.new
tom.details[:favorite_food] = "Sushi" # Allowed
tom.favorite_musician = "Adele" # raise error!

tom.favorite_fodd # => "Sushi"
```

## Wish list
1. Allow users to check what nested attributes are allowed under the parent attribute
2. Support other serialized attributes such as Array