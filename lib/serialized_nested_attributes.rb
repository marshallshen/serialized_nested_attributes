module SerializedNestedAttributes
  class ParentAttrNotFound < StandardError; end

  def define_nested_accessor(parent_attr_name, *names)
    verify_valid_parent_attribute(parent_attr_name)

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

    define_method("#{parent_attr_name}_attributes") do
      names
    end
  end

  def define_nested_writer(parent_attr_name, *names)
    verify_valid_parent_attribute(parent_attr_name)

    names.each do |name|
      define_method "#{name}=" do |value|
        self.send(parent_attr_name)[name] = value
      end
    end
  end

  def define_nested_reader(parent_attr_name, *names)
    verify_valid_parent_attribute(parent_attr_name)

    names.each do |name|
      define_method "#{name}" do
        self.send(parent_attr_name)[name]
      end

      define_method "#{name}?" do
        !!self.send(parent_attr_name)[name]
      end
    end
  end

  def method_missing(method, *args)
    case method.to_s
    when /(.*)_accessor/
      define_nested_accessor($1, *args)
    when /(.*)_writer/
      define_nested_writer($1, *args)
    when /(.*)_reader/
      define_nested_reader($1, *args)
    else
      raise
    end
  end

  private
  def verify_valid_parent_attribute(parent_attr_name)
    if parent_attr_not_accessible?(parent_attr_name)
      raise SerializedNestedAttributes::ParentAttrNotFound, "parent attr #{parent_attr_name} is not defined."
    end
  end

  def parent_attr_not_accessible?(parent_attr_name)
    if self.ancestors.include?(ActiveRecord::Base)
      !self.attribute_names.include?(parent_attr_name.to_s)
    else
      !self.instance_methods(false).include?(parent_attr_name.to_sym)
    end
  end
end