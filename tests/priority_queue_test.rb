# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/priority_queue'

class PriorityQueueTest < Minitest::Test
  def setup
    @pq = PriorityQueue.new
  end

  def test_inits_maxkey_to_array_holding_neg_infinity
    assert_equal [], @pq.priorities
  end

  def test_inits_q_to_an_empty_hash
    assert_equal Hash, @pq.q.class
    assert_empty @pq.q
  end

  def test_inits_empty_to_true
    assert_equal true, @pq.empty?
  end

  def test_inserts_an_item_into_empty_queue
    @pq.insert("b", 5)
    expected = { 5 => ["b"] }
    assert_equal expected, @pq.q
    assert_equal [5], @pq.priorities
    assert_equal false, @pq.empty?
  end

  def test_correctly_inserts_multiple_items
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    @pq.insert('y', 6)
    @pq.insert('a', 0)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('q', 10)
    expected = {2=>["b"], 5=>["x"], 6=>["y"], 0=>["a"], 3=>["z","w"], 10=>["q"]}
    assert_equal expected, @pq.q
    assert_equal [10, 6, 5, 3, 2, 0], @pq.priorities
  end

  def test_correctly_pulls_highest_items_returning_nil_when_empty
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    @pq.insert('y', 6)
    @pq.insert('a', 0)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal 'r', @pq.pull_highest
    assert_equal 'y', @pq.pull_highest
    assert_equal 'x', @pq.pull_highest
    assert_equal 'z', @pq.pull_highest
    assert_equal 'w', @pq.pull_highest
    assert_equal 'b', @pq.pull_highest
    assert_equal 'a', @pq.pull_highest
    assert_nil    @pq.pull_highest
    assert_equal Hash.new, @pq.q
  end

  def test_correctly_pulls_lowest_items_returning_nil_when_empty
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    @pq.insert('y', 6)
    @pq.insert('a', 0)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal 'a', @pq.pull_lowest
    assert_equal 'b', @pq.pull_lowest
    assert_equal 'z', @pq.pull_lowest
    assert_equal 'w', @pq.pull_lowest
    assert_equal 'x', @pq.pull_lowest
    assert_equal 'y', @pq.pull_lowest
    assert_equal 'r', @pq.pull_lowest
    assert_nil    @pq.pull_lowest
    assert_equal Hash.new, @pq.q
  end

  def test_can_mix_pull_highest_and_pull_lowest
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    @pq.insert('y', 6)
    @pq.insert('a', 0)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal 'a', @pq.pull_lowest
    assert_equal 'r', @pq.pull_highest
    assert_equal 'b', @pq.pull_lowest
    assert_equal 'y', @pq.pull_highest
    assert_equal 'z', @pq.pull_lowest
    assert_equal 'x', @pq.pull_highest
    assert_equal 'w', @pq.pull_lowest
    assert_nil    @pq.pull_highest
    assert_equal Hash.new, @pq.q
  end

  def test_find_max_returns_nil_for_empty_queue
    assert_nil @pq.find_max
  end

  def test_find_max_returns_the_highest_priority_item
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    assert_equal 'x', @pq.find_max
    @pq.pull_highest
    assert_equal 'b', @pq.find_max
  end

  def test_find_min_returns_nil_for_empty_queue
    assert_nil @pq.find_min
  end

  def test_find_max_returns_the_highest_priority_item
    @pq.insert('b', 2)
    @pq.insert('x', 5)
    assert_equal 'b', @pq.find_min
    @pq.pull_lowest
    assert_equal 'x', @pq.find_min
  end

  def test_returns_nil_for_empty_queue
    assert_nil @pq.pull_highest
    assert_equal true, @pq.empty?
  end

  def test_finds_items_by_priority
    @pq.insert('b', 2)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal ["z", "w"], @pq.find_by_priority(3)
  end

  def test_finds_item_by_label_and_priority
    @pq.insert('b', 2)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal "w", @pq.find_by_label_and_priority('w', 3)
  end

  def test_finds_item_by_label
    @pq.insert('b', 2)
    @pq.insert('z', 3)
    @pq.insert('w', 3)
    @pq.insert('r', 10)
    assert_equal "z", @pq.find_by_label('z')
  end
end
