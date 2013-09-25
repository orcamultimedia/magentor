module Magento
  # http://www.magentocommerce.com/api/soap/miscellaneous/store.list.html
  # 100  Requested store view not found.
  # 101  Requested attribute not found.
  class Store < Base
    class << self
      # store.list
      # Retrieve store list
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int SessionId - Session Id
      def list(*args)
        results = commit("list", *args)
        results.collect do |result|
          new(result)
        end
      end

      # catalog_product_attribute.options
      # Retrieve attribute options
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # mixed attributeId - attribute ID or code
      # mixed storeView - store view ID or code (optional)
      def options(*args)
        commit("options", *args)
      end
    end
  end
end
