# This is basically a bucket queue
# Items in the queue can be required to be unique
# insert: O(1), find_highest: O(#priorities), pull_highest: O(#priorities)
class PriorityQueue
  attr_reader :items, :priorities, :q
  def initialize
    @items = [] # maintain as an ordered list of unique items
    @priorities = [] # maintain as an ordered list
    @q = Hash.new {|hash, priority| hash[priority] = [] } # hash values: lists of indexes into items
  end

  def insert(item)
    # Uncomment if queue member uniqueness required
    # return if items.any? {|member| member.equal? item }
    @items << item
    priority = item.priority
    @q[priority] << (@items.size - 1)
    ndx = @priorities.bsearch_index{|p| priority >= p } || -1
    @priorities.insert(ndx, priority) if priority != @priorities[ndx]
  end
  alias_method :<<, :insert

  def pull_highest
    pull_item(@priorities.first)
  end

  def pull_lowest
    pull_item(@priorities.last)
  end

  def find_highest
    return nil if empty?
    max_priority_ndx = @q[@priorities.first].first
    @items[max_priority_ndx]
  end

  def find_lowest
    return nil if empty?
    min_priority_ndx = @q[@priorities.last].last
    @items[min_priority_ndx]
  end

  def empty?
    @priorities.empty?
  end

  def clear
    @items.clear
    @priorities.clear
    @q.clear
  end

# Extensions
  def find_by_priority(priority)
    @q[priority].map {|ndx| @items[ndx] }.first
  end

  def find_by_label_and_priority(label, priority)
    @q[priority].reduce([]) do |found, ndx|
      found << @items[ndx] if @items[ndx].label == label
      found
    end.first
  end

  def find_by_label(label)
    @q.reduce([]) do |found, (priority, ndxs)|
      selected_ndxs = ndxs.select {|ndx| @items[ndx].label == label }
      found.concat(selected_ndxs.map {|ndx| @items[ndx] })
    end.first
  end

private
  def pull_item(priority)
    return nil if empty?
    item_ndx = @q[priority].shift
    remove(priority) if @q[priority].empty?
    @items[item_ndx]
  end

  def remove(priority)
    @q.delete(priority)
    @priorities.delete(priority)
  end
end
