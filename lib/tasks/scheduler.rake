desc 'resync redis data'
task resync_redis_data: :environment do
  RedisConsistency.new.execute
end

desc 'resync data consistency'
task resync_data_consistency: :environment do
  DataConsistencyJob.perform_now
end

