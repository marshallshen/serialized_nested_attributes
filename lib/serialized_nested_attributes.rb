module SerializedNestedAttributes
  def self.included(klass)
    klass.extend self
  end

  def define_nested_accessor(parent_attr_name, *names)
    names.each do |name|
      define_method "#{name}" do
        self.send(parent_attr_name)[name]
      end

      define_method "#{name}=" do |value|
        self.send(parent_attr_name)[name] = value
      end

      define_method "#{name}?" do
        !!self.send(parent_attr_name)[name]
      end
    end
  end

  def method_missing(method, *args)
    if method.to_s =~ /(.*)_accessor$/
      parent_attr_name = $1
      define_nested_accessor(parent_attr_name, *args)
    end
  end
end