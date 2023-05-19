class Item
  include Comparable

  attr_reader :label
  attr_accessor :priority
  def initialize(label:, priority: Float::INFINITY)
    @label = label
    @priority = priority
  end

  def <=>(other)
    priority <=> other.priority
  end
end
