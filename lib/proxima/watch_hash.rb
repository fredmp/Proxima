

module Proxima

  def self.watch_hash(hash, &on_change)

    hash.instance_variable_set(:@on_change, on_change)

    hash.values.each do |value|
      Proxima.watch(value, &on_change)
    end

    class << hash

      def []=(*args)
        Proxima.watch(args[1], &@on_change)
        result = super
        @on_change.call if args[1]
        result
      end

      def clear(*args)
        result = super
        @on_change.call
        result
      end

      def delete(*args)
        result = super
        @on_change.call if result
        result
      end

      def delete_if(*args)
        result = super
        @on_change.call
        result
      end

      def merge!(*args)
        args[0].values.each do |value|
          Proxima.watch(value, &@on_change)
        end
        result = super
        @on_change.call
        result
      end

      def reject!(*args)
        result = super
        @on_change.call if result
        result
      end

      def select!(*args)
        result = super
        @on_change.call if result
        result
      end

      def store(*args)
        Proxima.watch(args[1], &@on_change)
        result = super
        @on_change.call
        result
      end

      def update(*args)
        args[0].values.each do |value|
          Proxima.watch(value, &@on_change)
        end
        result = super
        @on_change.call
        result
      end
    end
  end
end
