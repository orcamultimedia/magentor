module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_attribute
  # 100  Requested store view not found.
  # 101  Requested attribute not found.
  class ProductAttribute < Base
    class << self
      # catalog_product_attribute.list
      # Retrieve attribute list
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int setId - attribute set ID
      def list(*args)
        results = commit("list", *args)
        results.collect do |result|
          new(result)
        end
      end

      # catalog_product_attribute.info
      # Retrieve attribute information
      #
      # Return: array
      #
      # Arguments:
      #
      # mixed attribute - attribute code or ID
      def info(*args)
        new(commit("info", *args))
      end
      
      # catalog_product_attribute.update
      # Update product attribute
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed attribute - attribute code or ID
      # array data - array of data to update
      def update(*args)
        commit("update", *args)
      end

      # catalog_product_attribute.currentStore
      # Set/Get current store view
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # mixed storeView - store view id or code (optional)
      def current_store(*args)
        commit("currentStore", *args)
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
    
    # catalog_product_attribute.update
    # Update a product attribute
    #
    # Return: boolean
    #
    # Arguments:
    #
    # mixed attribute - attribute code or ID
    # hash data - hash of data to update (is turned into an array)
    def update_attributes(data)
      data.each_pair { |k, v| @attributes[k] = v }
      self.class.update(self.attribute_id, data)
    end
  end
end