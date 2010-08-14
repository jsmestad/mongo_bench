class MongoTest
  attr_accessor :threads, :iter, :db
  def initialize(opts)
    @threads = opts[:threads]
    @iter    = opts[:iter]
    @db      = opts[:db]
  end
  def run!
    @threads.times do
      Thread.new do
        @iter.times do
          test
        end
      end
    end
  end

  def test
    raise "Not Implemented"
  end
end
