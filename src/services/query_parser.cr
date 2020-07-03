module BankApp
  class QueryParser
    def self.sort_results(collection : Array, query_params)
      if !query_params["sort"]?
        return collection
      end

      sorted = case query_params["sort"]
               when "date"
                 collection.sort_by { |element| element.date }
               when "amount"
                 collection.sort_by { |element| element.amount }
               when "to_user"
                 collection.sort_by { |element| MemoryState.users_by_id[element.to_user].name }
               else
                 collection.sort_by { |element| element.id }
               end

      if query_params["direction"]? != "DESC"
        return sorted
      end

      sorted.reverse!
    end

    def self.filter_results(collection, query_params)
      if !query_params["search"]?
        return collection
      end

      collection.select { |element|
        MemoryState.users_by_id[element.to_user].name.includes?(query_params["search"])
      }
    end
  end
end
