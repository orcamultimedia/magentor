module Magento
  class Connection
    attr_accessor :session, :config, :logger

    def initialize(config = {})
      @logger ||= Logger.new(STDOUT)
      @config = config
      self
    end

    def client
      @client ||= XMLRPC::Client.new(config[:host], config[:path], config[:port], nil, nil, nil, nil, nil, config[:timeout])
    end

    def connect
      connect! if session.nil?
    end

    def call(method = nil, *args)
      cache? ? call_with_caching(method, *args) : call_without_caching(method, *args)
    end

    def multicall(*calls)
      multicall_without_caching(*calls)
    end

    private

      def connect!
        @session = client.call('login', config[:username], config[:api_key])
      end

      def cache?
        !!config[:cache_store]
      end

      def call_without_caching(method = nil, *args)
        call_client('call', method, args)
      rescue XMLRPC::FaultException => e
        logger.debug "exception: #{e.faultCode} -> #{e.faultString}"
        raise Magento::ApiError.new e.faultCode, e.faultString
      end

      def multicall_without_caching(*calls)
        ret = call_client('multiCall', calls)
        ret.each do |e|
          if e.class == Hash and e['isFault'] then
            logger.debug "exception: #{e["faultCode"]} -> #{e["faultMessage"]}"
          end
        end
        return ret
      rescue XMLRPC::FaultException => e
        raise Magento::ApiError, "#{e.faultCode} -> #{e.faultString}"
      end

      def call_with_caching(method = nil, *args)
        config[:cache_store].fetch(cache_key(method, *args)) do
          call_without_caching(method, *args)
        end
      end

      def call_client *args
        method = args.shift
        logger.debug "#{self.class.to_s} #{method}#{' async' if config[:async]}: #{args.map(&:inspect).join(', ')}"
        connect
        config[:async] ? client.call_async(method, session, *args) : client.call(method, session, *args)
      end

      def cache_key(method, *args)
        "#{config[:username]}@#{config[:host]}:#{config[:port]}#{config[:path]}/#{method}/#{args.inspect}"
      end

  end
end
