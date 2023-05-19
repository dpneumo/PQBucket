require_relative '../lib/priority_queue_bucket'
require_relative '../lib/item'

class InsertBenchmark
  PQ = PriorityQueueBucket
  PQsizes = [100, 1000, 10000, 100000, 1000000]
  MaxPriority = 100
  PQInsertSamples = 30
  PQSamples = 30
  TimeUnits = 'nanosec'

  attr_reader :items, :low_pri_item, :medium_pri_item, :high_pri_item
  def initialize
    @items = random_items
    @low_pri_item = Item.new(label: 'low_pri_item', priority: 1)
    @medium_pri_item = Item.new(label: 'med_pri_item', priority: MaxPriority/2)
    @high_pri_item = Item.new(label: 'high_pri_item', priority: MaxPriority)
  end

  def run
    puts "Insert:,"
    puts "qsize,low,med,high"
    csv_format = '%d, %0.0f, %0.0f, %0.0f'
    PQsizes.each do |qsize|
      low_pri_times =  []
      med_pri_times =  []
      high_pri_times = []
      PQSamples.times do |_|
        pq = base(qsize)
        low, med, high = queue_insertions(pq)
        low_pri_times << low
        med_pri_times << med
        high_pri_times << high
      end
      low_pri =  mean(low_pri_times)
      med_pri =  mean(med_pri_times)
      high_pri = mean(high_pri_times)
      puts csv_format % [qsize, low_pri, med_pri, high_pri]
    end
  end

  def queue_insertions(pq)
    rehearse(pq, low_pri_item)
    low_pri_time = mean_insert_time(pq, low_pri_item)
    rehearse(pq, medium_pri_item)
    medium_pri_time = mean_insert_time(pq, medium_pri_item)
    rehearse(pq, high_pri_item)
    high_pri_time = mean_insert_time(pq, high_pri_item)
    [ low_pri_time, medium_pri_time, high_pri_time ]
  end

  def rehearse(pq, item)
    insertion_time(pq, item)
  end

  def mean_insert_time(queue, item) # nanoseconds
    GC.start
    PQInsertSamples.times.reduce(0) do |accum_time,_|
      accum_time += insertion_time(queue, item)
      accum_time
    end*timescale/PQInsertSamples
  end

  def insertion_time(queue, item)
    pq = queue.dup
    t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    pq.insert(item)
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - t
  end

  def random_items
    prng = Random.new
    labels = ('a'..'zzzzz').map {|lbl| lbl }
    PQsizes.last.times.map do |i|
      Item.new(label: labels[i], priority: prng.rand(MaxPriority))
    end
  end

  def base(qsize)
    pq_base = PQ.new
    qsize.times {|i| pq_base.insert(items[i]) }
    pq_base.freeze
  end

  def timescale
    case TimeUnits
    when 'sec';      1
    when 'millisec'; 1000
    when 'microsec'; 1000000
    when 'nanosec';  1000000000
    else raise 'TimeScale Error'
    end
  end

  def mean(arry)
    arry.sum/arry.size
  end
end

InsertBenchmark.new.run
