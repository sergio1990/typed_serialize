ActiveRecord::Base.instance_eval do

  def typed_serialize(attr_name, class_name, *attributes)
    serialize(attr_name, class_name)

    after_initialize :typed_serialize_init

    def typed_serialize_init
      send("#{attr_name}=", class_name.new) unless send(attr_name)
    end
    private_class_method :typed_serialize_init

    if attributes.last.is_a?(Hash)
      attributes.last[:in] = attr_name
    else
      attributes = attributes << {:in=>attr_name}
    end
    
    serialized_accessor(attributes)
  end

  def serialized_accessor(*attributes)
    serialized_reader(attributes)
    serialized_writer(attributes)
  end

  def serialized_reader(*attributes)
    options = attributes.pop
    unless options.is_a?(Hash) and (owner = options[:in])
      raise ArgumentError, "Serialized reader needs a target. Supply an options hash with a :in key as the last argument (e.g. serialized_reader :hello, :in => :greeter)."
    end

    attributes.flatten.each do |attr_name|
      method_name = options[:prefix] ? "#{options[:in]}_#{attr_name}" : attr_name
      define_method(method_name) do
        send(options[:in])[attr_name]
      end
    end
  end

  def serialized_writer(*attributes)
    options = attributes.pop
    unless options.is_a?(Hash) and (owner = options[:in])
      raise ArgumentError, "Serialized writer needs a target. Supply an options hash with a :in key as the last argument (e.g. serialized_writer :hello, :in => :greeter)."
    end
    
    attributes.flatten.each do |attr_name|
      method_name = options[:prefix] ? "#{options[:in]}_#{attr_name}" : attr_name
      define_method("#{method_name}=") do |value|
        send(options[:in])[attr_name] = value
      end
    end
  end

end
