# SerializedNestedAttributes

A clean interface to access nested fields under a serilaized attribute

## Usage
```ruby
class Person < ActiveRecord::Base
  details_accessor :favorite_food, :favorite_musician
end

tom = Person.first
tom.details # => {:favorite_food => "Sushi", :favorite_musician => "Bob Dylan"}
```
Since details accessor is defined, you can also access the nested attributes like follows:

```ruby
tom.favorite_food # => "Sushi"
tom.favorite_musica
```
