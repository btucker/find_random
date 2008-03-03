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
        if limit == 1
          result_size = count(options)
          find(:first, options.merge(:offset => rand(result_size - 1)))
        else
          options[:select] = "id"
          options.delete(:limit)
          options.delete(:order)
          sql = construct_finder_sql(options)
          all_ids = connection.select_all(sql, "#{name} Load").collect!{|r| r['id']} 
          find(Array.new(limit){|i| all_ids.delete_at(rand(all_ids.length - 1))})
        end
      end
    end
  end
end
