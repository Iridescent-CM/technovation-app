class ParamKeys
  include Enumerable

  def initialize(arr, hsh)
    @keys = [arr, hsh].flatten.compact
  end

  def each(&block)
    @keys.each { |k| block.call(ParamKey.new(k)) }
  end

  def to_permitted_params_list
    [
      permitted_param_array_args,
      permitted_param_hash_args(convert_empty_to_nil: true)
    ].flatten.compact
  end

  def to_update_hash(given:, fallback:)
    params = {}

    each do |key|
      params[key.attribute_name] = given.fetch(key.original_name) {
        fallback.public_send(key.method_name)
      }
    end

    params
  end

  private

  def permitted_param_array_args
    map { |k| k.permit_format ? nil : k.original_name }.compact
  end

  def permitted_param_hash_args(opts = {})
    default_options = {convert_empty_to_nil: false}
    options = default_options.merge(opts)

    hsh = {}
    each do |k|
      k.permit_format ?
         hsh[k.original_name] = k.permit_format :
         false
    end

    if hsh.empty? && options[:convert_empty_to_nil]
      nil
    else
      hsh
    end
  end
end
