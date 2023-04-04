class PriorityQueue
  # This is basically a bucket queue
  attr_accessor :q, :keys
  def initialize
    @q = Hash.new {|hash, key| hash[key] = [] }
    @keys = []
    @empty = true
  end

  def insert(item, priority)
    q[priority] << item
    ndx = keys.bsearch_index{|key| priority >= key } || -1
    keys.insert(ndx, priority) if priority != keys[ndx]
    @empty = false
  end

  def pull_highest
    if keys.empty?
      @empty = true
      nil
    else
      get_item(keys.first, 0)
    end
  end

  def pull_lowest
    if keys.empty?
      @empty = true
      nil
    else
      get_item(keys.last, -1)
    end
  end

  def find_max
    return nil if empty?
    q[keys.first].first
  end

  def find_min
    return nil if empty?
    q[keys.last].first
  end

  def empty?
    @empty
  end

private
  def get_item(key, key_posn)
    item = q[key].shift
    if q[key].empty?
      q.delete(key)
      keys.delete_at(key_posn)
    end
    item
  end
end
