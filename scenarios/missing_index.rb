class MissingIndex < MongoTest
  def test
    # do a lot of reads to a collection without an index on @db here
  end
end
