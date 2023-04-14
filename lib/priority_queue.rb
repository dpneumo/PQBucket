class PriorityQueue
  # This is basically a bucket queue
  attr_accessor :q, :items, :priorities
  def initialize
    @items = [] # maintain as an ordered list of unique items
    @priorities = [] # maintain as an ordered list
    @q = Hash.new {|hash, priority| hash[priority] = [] } # hash values: lists of indexes into items
  end

  def insert(item, priority)
    items << item if ! items.include? item
    q[priority] << (items.size - 1)
    ndx = priorities.bsearch_index{|p| priority >= p } || -1
    priorities.insert(ndx, priority) if priority != priorities[ndx]
  end

  def pull_highest
    empty? ? nil : pull_item(priorities.first)
  end

  def pull_lowest
    empty? ? nil : pull_item(priorities.last)
  end

  def find_max
    return nil if empty?
    max_priority_ndx = q[priorities.first].first
    items[max_priority_ndx]
  end

  def find_min
    return nil if empty?
    min_priority_ndx = q[priorities.last].last
    items[min_priority_ndx]
  end

  def find_by_priority(priority)
    q[priority].map {|ndx| items[ndx] }
  end

  def find_by_label_and_priority(label, priority)
    q[priority].reduce([]) do |selections, ndx|
      selections << items[ndx] if items[ndx].to_s == label
      selections
    end.first
  end

  def find_by_label(label)
    q.each do |_, items|
      candidates = items.select {|itm| itm.to_s == label }
      next if candidates.empty?
      return candidates.first
    end
  end

  def empty?
    priorities.empty?
  end

private
  def pull_item(priority)
    item_ndx = q[priority].shift
    item = items[item_ndx]
    if q[priority].empty?
      q.delete(priority)
      priorities.delete(priority)
    end
    item
  end
end
