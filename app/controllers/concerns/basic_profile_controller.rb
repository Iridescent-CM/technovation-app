module BasicProfileController
  extend ActiveSupport::Concern

  module ClassMethods
    def with_profile(helper_method)
      instance_variable_set(:@profile_helper_method, helper_method)
    end

    def with_params(*params_safelist)
      instance_variable_set(:@params_safelist_arr, [])
      instance_variable_set(:@params_safelist_hsh, {})

      params_safelist.each do |item|
        case item
        when Symbol, String
          arr = instance_variable_get(:@params_safelist_arr)
          instance_variable_set(:@params_safelist_arr, arr.push(item))
        when Hash
          instance_variable_set(:@params_safelist_hsh, item)
        end
      end
    end

    def modify_params(func)
      instance_variable_set(:@params_modification_func, func)
    end
  end

  def update
    if ProfileUpdating.execute(profile, profile_params)
      render json: AccountSerializer.new(current_account).serialized_json
    else
      render json: { errors: profile.errors }, status: :unprocessessable_entity
    end
  end

  private
  def profile_params
    hashed_params = basic_profile_params.to_h
    params = {}

    params_safelist.each do |key|
      params[key.attribute_name] = hashed_params.fetch(key.original_name) {
        profile.public_send(key.method_name)
      }
    end

    params.merge({
      account_attributes: {
        id: current_account.id,

        first_name: hashed_params.fetch(:first_name) { account.first_name },
        last_name: hashed_params.fetch(:last_name) { account.last_name },

        referred_by_other: hashed_params.fetch(:referred_by_other) { account.referred_by_other },
        referred_by: hashed_params.fetch(:referred_by) { account.referred_by},

        gender: hashed_params.fetch(:gender_identity) { account.gender },
      },
    })
  end

  def basic_profile_params
    params.require(:basic_profile).permit(
      :first_name,
      :last_name,
      :referred_by,
      :referred_by_other,
      :gender_identity,
      *get_permitted_params_from_safelist,
    )
  end

  def get_permitted_params_from_safelist
    append_hsh = {}
    arr = []

    params_safelist.each do |key|
      if key.permit_format
        append_hsh[key.original_name] = key.permit_format
      else
        arr.push(key.original_name)
      end
    end

    append_hsh = nil if append_hsh.keys.none?
    [arr, append_hsh].flatten.compact
  end

  def params_safelist
    arr = self.class.instance_variable_get(:@params_safelist_arr)
    hsh = self.class.instance_variable_get(:@params_safelist_hsh)
    ParamKeys.new(arr, hsh)
  end

  def profile
    send(self.class.instance_variable_get(:@profile_helper_method))
  end

  class ParamKeys
    include Enumerable

    def initialize(arr, hsh)
      hsh = nil unless hsh.keys.any?
      @keys = [arr, hsh].flatten.compact
    end

    def each(&block)
      @keys.each { |k| block.call(ParamKey.new(k)) }
    end
  end

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
end