module GreenRiver #:nodoc:
  module FindRandom #:nodoc:

    def self.included(base) #:nodoc:
      base.extend SingletonMethods
    end

    module SingletonMethods #:nodoc:
      # Item.random(5, :conditions => ...)
      def random(*args)
        limit = args.first
        options = args.last.is_a?(::Hash) ? args.pop : {}
        # if only one row is requested, use the strategy of getting the size of the
        # result set, and then in a second query offset by a random int of that
        case limit
        when 0
          []
        when 1
          result_size = count(options)
          find(:first, options.merge(:offset => random_index(result_size)))
        else
          options[:select] = primary_key
          options.delete(:limit)
          options.delete(:order)
          sql = construct_finder_sql(options)
          all_ids = connection.select_all(sql, "#{name} Load IDs (find_random plugin)").collect!{|r| r['id']} 
          random_ids = Array.new([limit, all_ids.length].min){|i| all_ids.delete_at(random_index(all_ids.length))}
          find(random_ids)
        end
      end

      private
        def random_index(length)
          if (length <= 0)
            raise ArgumentError.new("Cannot return random index for length of '#{length}'.")
          end
          return rand(length)
        end
    end
  end
end
