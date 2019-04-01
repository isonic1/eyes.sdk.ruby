module Applitools
  module EyesConfigurationDSL
    def methods_to_delegate
      @methods_to_delegate ||= []
    end

    def accessor_methods
      @accessor_methods ||= []
    end

    def collect_method(field_name)
      accessor_methods.push field_name.to_sym
      methods_to_delegate.push field_name.to_sym
      methods_to_delegate.push "#{field_name}=".to_sym
    end

    def boolean_field(field_name)
      collect_method field_name
      define_method(field_name) do
        return true if config_hash[field_name]
        false
      end

      define_method("#{field_name}=") do |*args|
        value = args.shift
        if value
          config_hash[field_name] = true
        else
          config_hash[field_name] = false
        end
      end

      define_method("defined_#{field_name}?") do
        true
      end
    end

    def string_field(field_name)
      collect_method field_name
      define_method(field_name) do
        return '' unless config_hash[field_name.to_sym].is_a? String
        config_hash[field_name.to_sym]
      end

      define_method("#{field_name}=") do |*args|
        value = args.shift
        raise Applitools::EyesIllegalArgument, "Expected #{field_name} to be a String but got #{value.class} instead" unless value.is_a? String
        config_hash[field_name.to_sym] = value.freeze
      end

      define_method("defined_#{field_name}?") do
        !send(field_name).empty?
      end
    end

    # def rectangle_size_field(field_name)
    #   collect_method field_name
    #   define_method(field_name) do
    #     return Applitools::RectangleSize.from_hash(width: 0, height: 0) unless config_hash[field_name.to_sym].is_a? Applitools::RectangleSize
    #     config_hash[field_name.to_sym]
    #   end
    #
    #   define_method("#{field_name}=") do |*args|
    #     value = args.shift
    #     raise Applitools::EyesIllegalArgument, "Expected #{field_name} to be an Applitools::RectangleClass but got #{value.class} instead" unless value.is_a? Applitools::RectangleSize
    #     config_hash[field_name.to_sym] = value
    #   end
    #
    #   define_method("defined_#{field_name}?") do
    #     send(field_name).square > 0
    #   end
    # end

    # def batch_info_field(field_name)
    #   collect_method field_name
    #   define_method(field_name) do
    #     config_hash[field_name.to_sym]
    #   end
    #
    #   define_method("#{field_name}=") do |*args|
    #     value = args.shift
    #     raise(
    #       Applitools::EyesIllegalArgument,
    #       "Expected Applitools::BatchInfo but got #{value.class}"
    #     ) unless value.is_a? Applitools::BatchInfo
    #     config_hash[field_name.to_sym] = value
    #   end
    #
    #   define_method("defined_#{field_name}?") do
    #     value = send(field_name)
    #     value.is_a? Applitools::BatchInfo
    #   end
    # end

    def object_field(field_name, klass)
      collect_method field_name
      define_method(field_name) do
        config_hash[field_name.to_sym]
      end
      define_method("#{field_name}=") do |*args|
        value = args.shift
        raise(
            Applitools::EyesIllegalArgument,
            "Expected #{klass} but got #{value.class}"
        ) unless value.is_a? klass
        config_hash[field_name.to_sym] = value
      end
      define_method("defined_#{field_name}?") do
        value = send(field_name)
        value.is_a? klass
      end
    end

    def int_field(field_name)
      collect_method(field_name)
      define_method(field_name) do
        config_hash[field_name.to_sym]
        # value =
        # return value if value.is_a? Integer
        # 0
      end

      define_method("#{field_name}=") do |*args|
        value = args.shift
        return config_hash[field_name.to_sym] = value if value.is_a? Integer
        return config_hash[field_name.to_sym] = value.to_i if value.respond_to? :to_i
        raise Applitools::EyesIllegalArgument, "Expected #{field_name} to be an Integer"
      end

      define_method("defined_#{field_name}?") do
        value = send(field_name)
        value.is_a? Integer
      end
    end

    def enum_field(field_name, available_values_array)
      collect_method(field_name)

      define_method(field_name) do
        config_hash[field_name.to_sym]
      end

      define_method("#{field_name}=") do |*args|
        value = args.shift
        raise(
            Applitools::EyesIllegalArgument,
            "Unknown #{field_name} #{value}. Allowed session types: " \
            "#{available_values_array.join(', ')}"
        ) unless available_values_array.include? value
        config_hash[field_name.to_sym] = value
      end

      define_method("defined_#{field_name}?") do
        available_values_array.include? send(field_name)
      end
    end
  end
end