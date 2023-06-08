# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/pq_bucket'
require_relative '../lib/item'

class PQBucketTest < Minitest::Test
  def setup
    @pq = PQBucket.new
    @pq.insert(Item.new(label: 'b', priority: 2))
    @pq.insert(Item.new(label: 'x', priority: 6))
    @pq.insert(Item.new(label: 'y', priority: 6))
    @pq.insert(Item.new(label: 'z', priority: 3))
    @pq.insert(Item.new(label: 'w', priority: 3))
    @pq.insert(Item.new(label: 'r', priority: 10))
  end

  def test_an_alias_for_insert # <<
    @pq << Item.new(label: 'm', priority: 20)
    assert_equal 'm', @pq.pull_highest.label
  end

  def test_correctly_pulls_highest_items_returning_nil_when_empty
    assert_equal 'r', @pq.pull_highest.label
    assert_equal 'x', @pq.pull_highest.label
    assert_equal 'y', @pq.pull_highest.label
    assert_equal 'z', @pq.pull_highest.label
    assert_equal 'w', @pq.pull_highest.label
    assert_equal 'b', @pq.pull_highest.label
    assert_nil    @pq.pull_highest
  end

  def test_find_highest_returns_nil_for_empty_queue
    assert_nil PQBucket.new.find_highest
  end

  def test_find_highest_returns_the_highest_priority_item
    assert_equal 'r', @pq.find_highest.label
    @pq.pull_highest
    assert_equal 'x', @pq.find_highest.label
  end

  def test_identifies_empty_queue
    pq = PQBucket.new
    assert pq.empty?
    pq.insert(Item.new(label:'T', priority: 5))
    refute pq.empty?
    pq.pull_highest
    assert pq.empty?
  end

  def test_clear_empties_the_priority_queue
    @pq.clear
    assert @pq.empty?
  end

  def test_returns_correct_queue_size
    assert_equal 6, @pq.size
    @pq.pull_highest
    assert_equal 5, @pq.size
  end

# Extensions tests
  def test_returns_string_representation_of_queue
    expect = {10=>["r"], 6=>["x", "y"], 3=>["z", "w"], 2=>["b"]}
    assert_equal expect, @pq.to_s
  end

  def test_correctly_pulls_lowest_items_returning_nil_when_empty
    assert_equal 'b', @pq.pull_lowest.label
    assert_equal 'z', @pq.pull_lowest.label
    assert_equal 'w', @pq.pull_lowest.label
    assert_equal 'x', @pq.pull_lowest.label
    assert_equal 'y', @pq.pull_lowest.label
    assert_equal 'r', @pq.pull_lowest.label
    assert_nil    @pq.pull_lowest
  end

  def test_can_mix_pull_highest_and_pull_lowest
    assert_equal 'r', @pq.pull_highest.label
    assert_equal 'b', @pq.pull_lowest.label
    assert_equal 'x', @pq.pull_highest.label
    assert_equal 'z', @pq.pull_lowest.label
    assert_equal 'y', @pq.pull_highest.label
    assert_equal 'w', @pq.pull_lowest.label
    assert_nil    @pq.pull_highest
  end

  def test_find_lowest_returns_nil_for_empty_queue
    pq = PQBucket.new
    assert_nil pq.find_lowest
  end

  def test_find_lowest_returns_the_lowest_priority_item
    assert_equal 'b', @pq.find_lowest.label
    @pq.pull_lowest
    assert_equal 'z', @pq.find_lowest.label
  end

  def test_find_by_priority_returns_first_inserted_with_that_priority
    assert_equal "z", @pq.find_by_priority(3).label
  end

  def test_find_by_priority_returns_nil_if_item_not_found
    assert_nil @pq.find_by_priority(4)
  end

  def test_find_by_label_and_priority_returns_item_with_label_and_priority
    assert_equal "w", @pq.find_by_label_and_priority('w', 3).label
  end

  def test_find_by_label_and_priority_returns_nil_if_item_not_found
    assert_nil @pq.find_by_label_and_priority('a', 3)
    assert_nil @pq.find_by_label_and_priority('w', 4)
    assert_nil @pq.find_by_label_and_priority('a', 4)
  end

  def test_find_by_label_returns_first_inserted_item_with_label
    assert_equal "z", @pq.find_by_label('z').label
  end

  def test_find_by_label_returns_nil_if_label_not_found
    assert_nil @pq.find_by_label('a')
  end

# Implementation tests
  def test_inits_priorities_to_empty_array
    pq = PQBucket.new
    assert_equal Array, pq.priorities.class
    assert_empty pq.priorities
  end

  def test_inits_q_to_an_empty_hash
    pq = PQBucket.new
    assert_equal Hash, pq.q.class
    assert_empty pq.q
  end

  def test_insert_details_for_multiple_items
    expected = {2=>[0], 6=>[1, 2], 3=>[3, 4], 10=>[5]}
    assert_equal expected, @pq.q
    assert_equal ['b', 'x', 'y', 'z', 'w', 'r'], @pq.items.map {|itm| itm.label }
    assert_equal [2, 3, 6, 10], @pq.priorities
    assert ! @pq.empty?
  end

  def test_clear_empties_the_pq_bucket
    @pq.clear
    assert @pq.q.empty?
  end
end
