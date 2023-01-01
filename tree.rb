require_relative './node'

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr.sort.uniq)
  end

  def build_tree(sorted_arr)
    return nil if sorted_arr.empty?

    mid = (sorted_arr.length / 2).floor
    root_node = Node.new(sorted_arr[mid])

    root_node.left = build_tree(sorted_arr[0...mid])
    root_node.right = build_tree(sorted_arr[(mid + 1)..])

    root_node
  end

  def find(val, node = root)
    return node if node.nil? || node.data == val

    val < node.data ? find(val, node.left) : find(val, node.right)
  end

  def insert(val, node = root)
    return nil if val == node.data

    if val < node.data
      node.left.nil? ? node.left = Node.new(val) : insert(val, node.left)
    else
      node.right.nil? ? node.right = Node.new(val) : insert(val, node.right)
    end
  end

  def delete(val, node = root)
    return node if node.nil?

    if val < node.data
      node.left = delete(val, node.left)
      node
    elsif val > node.data
      node.right = delete(val, node.right)
      node
    elsif val == node.data
      return node.right if node.left.nil?

      return node.left if node.right.nil?

      # go the the right node of the node to be deleted
      node.right = get_successor(node.right, node)
      node
    end
  end

  def pre_order(node = root)
    return if node.nil?

    puts node.data.to_s
    pre_order(node.left)
    pre_order(node.right)
  end

  def in_order(node = root)
    return if node.nil?

    in_order(node.left)
    puts node.data.to_s
    in_order(node.right)
  end

  def post_order(node = root)
    return if node.nil?

    in_order(node.left)
    in_order(node.right)
    puts node.data.to_s
  end

  def level_order(queue = [], node = root)
    return if queue.empty?

    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?

    level_order(queue, queue.shift)
  end

  def height(node = root)
    return -1 if node.nil?

    find_max(height(node.left), height(node.right)) + 1
  end

  def depth(node = root)
    return -1 if node.nil?

    left = depth(node.left)
    right = depth(node.right)

    left > right ? left + 1 : right + 1
  end

  def balance?(node = root)
    return true if node.nil?

    left = height(node.left)
    right = height(node.right)

    return true if (left - right <= 1) && balance?(node.left) == true && balance?(node.right) == true

    false
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def get_successor(node, node_to_delete)
    # if current node has left child, recursively call this function
    if node.left
      node.left = get_successor(node.left, node_to_delete)
      node
    else
      node_to_delete.data = node.data
      # always return the right part of the node
      node.right
    end
  end

  def find_max(a, b)
    a >= b ? a : b
  end
end

t = Tree.new(Array.new(5) { rand(1..100) })
t.pretty_print
# # p t.pretty_print
# t.insert(4)
# p t.pretty_print
# t.insert(202)
# p t.pretty_print
# t.delete(100)
# p t.pretty_print
# p t.find(3)
# p t.height
# p t.pre_order
# p t.in_order
# p t.post_order
# p t.height
# p t.depth
p t.balance?

10.times do 
  num = rand(100..110)
  t.insert(num)
end
puts '-------'
t.pretty_print
p t.balance?