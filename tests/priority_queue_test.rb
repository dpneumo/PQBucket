# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/priority_queue'

class PriorityQueueTest < Minitest::Test
  def setup
    @pq = PriorityQueue.new
    @pq.insert('b', 2)
    @pq.insert('x', 6)
    @pq.insert('y', 6)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
  end

  def test_inits_priorities_to_empty_array
    pq = PriorityQueue.new
    assert_equal Array, pq.priorities.class
    assert_empty pq.priorities
  end

  def test_inits_q_to_an_empty_hash
    pq = PriorityQueue.new
    assert_equal Hash, pq.q.class
    assert_empty pq.q
  end

  def test_empty_returns_true_at_startup
    pq = PriorityQueue.new
    assert pq.empty?
  end

  def test_correctly_inserts_multiple_items
    expected = {2=>[0], 6=>[1, 2], 3=>[3, 4], 10=>[5]}
    assert_equal expected, @pq.q
    assert_equal ['b', 'x', 'y', 'z', 'w', 'r'], @pq.items
    assert_equal [10, 6, 3, 2], @pq.priorities
    assert ! @pq.empty?
  end

  def test_correctly_pulls_highest_items_returning_nil_when_empty
    assert_equal 'r', @pq.pull_highest
    assert_equal 'x', @pq.pull_highest
    assert_equal 'y', @pq.pull_highest
    assert_equal 'z', @pq.pull_highest
    assert_equal 'w', @pq.pull_highest
    assert_equal 'b', @pq.pull_highest
    assert_nil    @pq.pull_highest
    assert @pq.empty?
    assert_equal Hash.new, @pq.q
  end

  def test_correctly_pulls_lowest_items_returning_nil_when_empty
    assert_equal 'b', @pq.pull_lowest
    assert_equal 'z', @pq.pull_lowest
    assert_equal 'w', @pq.pull_lowest
    assert_equal 'x', @pq.pull_lowest
    assert_equal 'y', @pq.pull_lowest
    assert_equal 'r', @pq.pull_lowest
    assert_nil    @pq.pull_lowest
    assert @pq.empty?
    assert_equal Hash.new, @pq.q
  end

  def test_can_mix_pull_highest_and_pull_lowest
    assert_equal 'r', @pq.pull_highest
    assert_equal 'b', @pq.pull_lowest
    assert_equal 'x', @pq.pull_highest
    assert_equal 'z', @pq.pull_lowest
    assert_equal 'y', @pq.pull_highest
    assert_equal 'w', @pq.pull_lowest
    assert_nil    @pq.pull_highest
    assert_equal Hash.new, @pq.q
  end

  def test_find_highest_returns_nil_for_empty_queue
    pq = PriorityQueue.new
    assert_nil pq.find_highest
  end

  def test_find_highest_returns_the_highest_priority_item
    assert_equal 'r', @pq.find_highest
    @pq.pull_highest
    assert_equal 'x', @pq.find_highest
  end

  def test_find_lowest_returns_nil_for_empty_queue
    pq = PriorityQueue.new
    assert_nil pq.find_lowest
  end

  def test_find_lowest_returns_the_lowest_priority_item
    assert_equal 'b', @pq.find_lowest
    @pq.pull_lowest
    assert_equal 'w', @pq.find_lowest
  end

  def test_find_by_priority_returns_first_inserted_with_that_priority
    assert_equal "z", @pq.find_by_priority(3)
  end

  def test_find_by_priority_returns_nil_if_item_not_found
    assert_nil @pq.find_by_priority(4)
  end

  def test_find_by_label_and_priority_returns_item_with_label_and_priority
    assert_equal "w", @pq.find_by_label_and_priority('w', 3)
  end

  def test_find_by_label_and_priority_returns_nil_if_item_not_found
    assert_nil @pq.find_by_label_and_priority('a', 3)
    assert_nil @pq.find_by_label_and_priority('w', 4)
    assert_nil @pq.find_by_label_and_priority('a', 4)
  end

  def test_find_by_label_returns_first_inserted_item_with_label
    assert_equal "z", @pq.find_by_label('z')
  end

  def test_find_by_label_returns_nil_if_label_not_found
    assert_nil @pq.find_by_label('a')
  end

  def test_clear_empties_the_priority_queue
    @pq.clear
    assert @pq.empty?
    assert @pq.q.empty?
  end
end
