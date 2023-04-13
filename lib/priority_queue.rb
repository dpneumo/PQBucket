class PriorityQueue
  # This is basically a bucket queue
  attr_accessor :q, :priorities
  def initialize
    @q = Hash.new {|hash, priority| hash[priority] = [] } # hash values: lists of items
    @priorities = [] # maintain as an ordered list
    @empty = true
  end

  def insert(item, priority)
    q[priority] << item
    ndx = priorities.bsearch_index{|p| priority >= p } || -1
    priorities.insert(ndx, priority) if priority != priorities[ndx]
    @empty = false
  end

  def pull_highest
    if priorities.empty?
      @empty = true
      nil
    else
      pull_item(priorities.first, 0)
    end
  end

  def pull_lowest
    if priorities.empty?
      @empty = true
      nil
    else
      pull_item(priorities.last, -1)
    end
  end

  def find_max
    return nil if empty?
    q[priorities.first].first
  end

  def find_min
    return nil if empty?
    q[priorities.last].first
  end

  def find_by_priority(priority)
    q[priority]
  end

  def find_by_label_and_priority(label, priority)
    q[priority].select {|itm| itm.to_s == label }.first
  end

  def find_by_label(label)
    q.each do |_, items|
      candidates = items.select {|itm| itm.to_s == label }
      next if candidates.empty?
      return candidates.first
    end
  end

  def empty?
    @empty
  end

private
  def pull_item(priority, priority_posn)
    item = q[priority].shift
    if q[priority].empty?
      q.delete(priority)
      priorities.delete_at(priority_posn)
    end
    item
  end
end
