require 'mongo'
require 'logger'
require 'benchmark'

class MongoBench

  DBS_TO_IGNORE = []
  COLS_TO_IGNORE = ['$cmd']

  attr_reader :threads, :server, :port, :username, :password, :db, :iter

  def initialize(opts)
    @threads = opts[:threads]
    @server, @port = opts[:server], opts[:port]
    @username, @password = opts[:username], opts[:password]
    @db = opts[:db]
    @dir = opts[:dir]
    @iter = opts[:iterations]

    if @username && @password
      puts "adding auth for #{username}/#{password} to admin"
      connection.add_auth('admin', @username, @password)
      connection.apply_saved_authentication
    end
  end

  def run!
    db=connection.db(@db)
    tests = []
    Dir[File.join(File.dirname(__FILE__),'..','tests/*')].each do |f|
      require f
      tests << File.basename(f,'.rb').sub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
    tests.each do |t|
      Benchmark.bm(14) do |x|
        test = Kernel.const_get(t).new({:iter => @iter, :threads => @threads, :db => db})
        x.report("#{t} run: ") { test.run!}
      end
    end
  end

  protected

    def connection
      @connection ||= Mongo::Connection.new(@server, @port,:pool_size => @threads)
    end

end

