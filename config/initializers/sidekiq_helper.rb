module SidekiqHelper
  BATCH_SIZE = 5_000

  def self.included(base)
    base.extend(ClassMethods)
  end

  def job_args(ending_id, starting_id = 1, *args)
    start_batch = (starting_id.to_f / BATCH_SIZE.to_f).floor
    if start_batch == 0
      start_batch = 1
    end
    end_batch = (ending_id.to_f / BATCH_SIZE.to_f).ceil
    start_batch.upto(end_batch).each_with_object([]) do |batch, jobs|
      jobs.push([batch].concat(args))
    end
  end

  def build_ids(batch)
    start = ((batch - 1) * BATCH_SIZE) + 1
    finish = batch * BATCH_SIZE
    (start..finish).to_a
  end

  def enqueue_all(klass, sidekiq_class, *args)
    if last_id = klass.last&.id
      defaults = {
        "class" => sidekiq_class
      }
      (1..last_id).each_slice(10_000) do |slice|
        ids = slice.map { |id| [id, *args] }
        Sidekiq::Client.push_bulk(
          defaults.merge("args" => ids)
        )
      end
    end
  end

  def add_to_queue(queue, id)
    Sidekiq.redis { |redis| redis.sadd?(queue, id) }
  end

  def dequeue_ids(queue)
    temporary_set = "#{self.class.name}-#{jid}"

    (_, _, ids) = Sidekiq.redis do |redis|
      redis.pipelined do  |pipeline|
        pipeline.renamenx(queue, temporary_set)
        pipeline.expire(temporary_set, 60)
        pipeline.smembers(temporary_set)
      end
    end

    ids
  rescue Redis::CommandError => exception
    if exception.message =~ /no such key/i
      logger.info("Nothing to do")
      return nil
    end
    raise
  end

  module ClassMethods
    def local_queue(name)
      "#{name}_#{Socket.gethostname}"
    end
  end
end
