# This is a bucket queue
# Items in the queue can be required to be unique
# insert: O(1), find_highest: O(#priorities), pull_highest: O(#priorities)
class PriorityQueueBucket
  attr_reader :items, :priorities, :q

  def initialize
    @items = [] # list of items in insertion order. Can force uniqueness.
    @priorities = [] # list of unique priorities in ascending order.
    @q = Hash.new {|hash, priority| hash[priority] = [] } # hash values: lists of indexes into items
  end

  def insert(item)
    # return unless unique?(item)
    @items << item
    priority = item.priority
    add_item_to_priority_bucket(item, priority)
    update_priorities(priority)
  end
  alias_method :<<, :insert

  #NOTE: The pull_highest order for items of equal priority is FIFO
  def pull_highest
    pull_item(@priorities.last)
  end

  #Note: Returns FIRST item inserted at HIGHEST Priority - FIFO
  def find_highest
    return nil if empty?
    highest_priority = @q[@priorities.last]
    @items[highest_priority.first]
  end

  def empty?
    @priorities.empty?
  end

  def size
    @q.each_value.reduce(0) do |acc, item_ndxs|
      acc += item_ndxs.size
      acc
    end
  end

  def clear
    @items.clear
    @priorities.clear
    @q.clear
  end

# Extensions
  #NOTE: Deletes from Queue and returns FIRST item inserted at LOWEST Priority - FIFO
  def pull_lowest
    pull_item(@priorities.first)
  end

  #Note: Returns FIRST item inserted at LOWEST Priority - FIFO
  def find_lowest
    return nil if empty?
    lowest_priority = q[@priorities.first]
    @items[lowest_priority.first]
  end

  def to_s
    @priorities.reduce({}) do |acc, priority|
      lbls = @q[priority].map do |itm_ndx|
        itm = @items[itm_ndx]
        itm ? itm.label : 'Nil'
      end
      acc[priority] = lbls
      acc
    end
  end

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
  def unique?(item)
    @items.any? {|member| member.equal? item }
  end

  def add_item_to_priority_bucket(item, priority)
    @q[priority] << (@items.size - 1) #index of the item just added
  end

  def update_priorities(priority)
    ndx = @priorities.bsearch_index{|p| p >= priority } || -1
    @priorities.insert(ndx, priority) if priority != @priorities[ndx]
  end

  def pull_item(priority)
    # FIFO at given priority
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
