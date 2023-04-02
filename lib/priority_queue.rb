class PriorityQueue
  # This is basically a bucket queue
  attr_accessor :q, :keys
  def initialize
    @q = Hash.new {|hash, key| hash[key] = [] }
    @keys = [-Float::INFINITY, Float::INFINITY]
    @empty = true
  end

  def insert(item, priority)
    q[priority] << item
    ndx = keys.bsearch_index{|key| key >= priority } || -1
    keys.insert(ndx, priority) if priority != keys[ndx]
    @empty = false
  end

  def pull_highest
    highest_key_posn = -2
    key = keys[highest_key_posn]
    if key == -Float::INFINITY
      @empty = true
      item = nil
    else
      item = get_item(key, highest_key_posn)
    end
    item
  end

  def pull_lowest
    lowest_key_posn = 1
    key = keys[lowest_key_posn]
    if key == Float::INFINITY
      @empty = true
      item = nil
    else
      item = get_item(key, lowest_key_posn)
    end
    item
  end

  def find_max
    q[keys[-2]].last
  end

  def find_min
    q[keys[1]].last
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
