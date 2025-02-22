module Search
  class Connection
    PATHS = {
      document: "/%{index}/_doc/%{id}",
      search:   "/%{index}/_search",
      validate: "/%{index}/_validate/query",
      msearch:  "/%{index}/_msearch",
      count:    "/%{index}/_count",
      refresh:  "/_refresh",
      bulk:     "/_bulk",
    }

    def initialize(url, username: nil, password: nil)
      @url = url
      @username = username
      @password = password
    end

    def search(index, query:, page: 1, per_page: WillPaginate.per_page)
      path = PATHS[:search] % {index:}
      data = request(:get, path, json: query, params: {
        :_source => false,
        :from    => (page.to_i - 1) * per_page,
        :size    => per_page
      })
      Response.new(data, page: page, per_page: per_page)
    end

    def index(index, id:, document:)
      path = PATHS[:document] % {index:, id:}
      request(:put, path, json: document)
    end

    def get(index, id:)
      path = PATHS[:document] % {index:, id:}
      request(:get, path)
    end

    def delete(index, id:)
      path = PATHS[:document] % {index:, id:}
      request(:delete, path)
    end

    def bulk(records)
      options = {
        body: prepare_bulk_request(records),
        params: {"filter_path" => "took"}
      }
      request(:post, PATHS[:bulk], options)
    end

    def msearch(index, records:)
      options = {
        body: prepare_bulk_request(records)
      }
      path = PATHS[:msearch] % {index:}
      request(:post, path, options).safe_dig("responses")&.map do |data|
        Response.new(data)
      end
    end

    def validate(index, query:)
      path = PATHS[:validate] % {index:}
      result = request(:get, path, json: query)
      result.safe_dig("valid")
    end

    def count(index)
      path = PATHS[:count] % {index:}
      result = request(:get, path)
      result.safe_dig("count")
    end

    def refresh
      request(:post, PATHS[:refresh])
    end

    def all_matches(index, query:)
      callback = proc do |page|
        search(index, query: query, page: page, per_page: 1_000)
      end
      result = callback.call(1)
      2.upto(result.pagination.total_pages).each_with_object(result.ids) do |page, ids|
        ids.concat callback.call(page).ids
      end
    end

    def request(method, path, options = {})
      unless path.start_with?("/")
        path = "/#{path}"
      end
      connection.request(method.to_sym, path, options).parse
    end

    def close
      Rails.logger.info("Closing search connection")
      connection.close
    end

    private

    def connection
      @connection ||= begin
        client = HTTP
          .use(instrumentation: { instrumenter: ActiveSupport::Notifications.instrumenter, namespace: "search" })
          .persistent(@url)
          .headers(content_type: "application/json")
        client = client.basic_auth(user: @username, pass: @password) if @username && @password
        client
      end
    end

    def prepare_bulk_request(records)
      records.map(&:to_request).join("\n") + "\n"
    end
  end
end