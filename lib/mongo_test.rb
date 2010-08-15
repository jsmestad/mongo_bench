class MongoTest
  attr_accessor :threads, :iter, :db
  def initialize(opts)
    @threads = opts[:threads]
    @iter    = opts[:iter]
    @db      = opts[:db]
  end
  def run!
    result = nil
    @threads.times do
      Thread.new do
        @iter.times do
          result = test
        end
      end
    end
    return result
  end

  def test
    raise "Not Implemented"
  end
end
