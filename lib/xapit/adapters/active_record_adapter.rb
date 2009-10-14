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
      if (args and args.kind_of?(Array))
        args[0].delete(:conditions)
      end
      
      @target.find(ids, *args)
    end
    
    def find_each(*args, &block)
      records = @target.find(:all, *args)
      records.each { |record| yield record }
    end
  end
end
