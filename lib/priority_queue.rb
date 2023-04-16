class PriorityQueue
  # This is basically a bucket queue
  attr_accessor :items, :priorities, :q
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
    pull_item(priorities.first)
  end

  def pull_lowest
    pull_item(priorities.last)
  end

  def find_highest
    return nil if empty?
    max_priority_ndx = q[priorities.first].first
    items[max_priority_ndx]
  end

  def find_lowest
    return nil if empty?
    min_priority_ndx = q[priorities.last].last
    items[min_priority_ndx]
  end

  def find_by_priority(priority)
    q[priority].map {|ndx| items[ndx] }.first
  end

  def find_by_label_and_priority(label, priority)
    q[priority].reduce([]) do |found, ndx|
      found << items[ndx] if items[ndx].to_s == label
      found
    end.first
  end

  def find_by_label(label)
    q.reduce([]) do |found, (priority, ndxs)|
      selected_ndxs = ndxs.select {|ndx| items[ndx] == label }
      found.concat(selected_ndxs.map {|ndx| items[ndx] })
    end.first
  end

  def empty?
    priorities.empty?
  end

  def clear
    items.clear
    priorities.clear
    q.clear
  end

private
  def pull_item(priority)
    return nil if empty?
    item_ndx = q[priority].shift
    remove(priority) if q[priority].empty?
    items[item_ndx]
  end

  def remove(priority)
    q.delete(priority)
    priorities.delete(priority)
  end
end
