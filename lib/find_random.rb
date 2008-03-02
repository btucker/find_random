module GreenRiver #:nodoc:
  module FindRandom #:nodoc:

    def self.included(base) #:nodoc:
      base.extend SingletonMethods
    end

    module SingletonMethods #:nodoc:
      # Item.random(5, :conditions => ...)
      def random(*args)
        limit = args.first
        options = args.last.is_a?(::Hash) ? pop : {}
        options[:select] = "id"
        options.delete(:limit)
        options.delete(:order)
        sql = construct_finder_sql(options)
        ids = connection.select_all(sql, "#{name} Load").collect! do |record| 
                record['id'] 
              end.sort_by { rand }.slice(0, limit)
        find(ids)
      end
    end
  end
end
