module Xapit
  # This adapter is used for all ActiveRecord models. See AbstractAdapter for details.
  class ActiveRecordAdapter < AbstractAdapter
    def self.for_class?(member_class)
      member_class.ancestors.map(&:to_s).include? "ActiveRecord::Base"
    end
    
    def find_single(id, *args)
      @target.find_by_id(id, *args)
    end
    
    def find_multiple(ids, *args)
      if (args and args.kind_of?(Array) and args.size > 0)
        args[0].delete(:conditions)
      end
      
      args[0] ||= {}
      
      args[0][:conditions] = ["id IN (?)", ids]
      
      @target.find(:all, *args)
    end
    
    def find_each(*args, &block)
      records = @target.find(:all, *args)
      RAILS_DEFAULT_LOGGER.info("  #{records.size} records to index...")
      records.each do |record| 
        RAILS_DEFAULT_LOGGER.debug("  Indexing #{record.id.to_s}...")
        yield record 
      end
    end
  end
end
