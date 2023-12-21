class ParamKey
  attr_reader :attribute_name, :method_name, :original_name, :permit_format

  def initialize(key)
    case key
    when Hash
      key.each do |k, opts|
        @key = k
        @original_name = k

        if opts.any? && opts.fetch(:rename) { false }
          @attribute_name = opts[:attribute_name]
          @method_name = opts[:method_name]
        else
          @permit_format = opts
        end
      end
    else
      @key = key
    end
  end

  def attribute_name
    @attribute_name ||= @key
  end

  def method_name
    @method_name ||= @key
  end

  def original_name
    @original_name ||= @key
  end
end
