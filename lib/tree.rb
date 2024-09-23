require_relative 'node'

class Tree
  attr_accessor :root_node, :root, :arr

  def initialize(entry)
    @arr = entry.uniq
    @root = build_tree(@arr)
  end

  def build_tree(arr, start = 0, finish = arr.length - 1)
    return if start > finish

    mid = (start + finish) / 2
    root_node = Node.new(arr[mid])

    root_node.left = build_tree(arr, start, mid - 1)
    root_node.right = build_tree(arr, mid + 1, finish)
    root_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(root, value)
    if root.nil?
      root = Node.new(value)
    elsif value < root.data
      root.left = insert(root.left, value)
    elsif value > root.data
      root.right = insert(root.right, value)
    end
    root
  end

  def delete(root, value)
    parent = nil
    node = root

    while node && node.data != value # the node in node && node.data necessary to exit iteration incase value isnt in tree.
      parent = node
      node = value > node.data ? node.right : node.left
    end
    return unless node

    if node.left.nil? && node.right.nil?
      parent.left == node ? parent.left = nil : parent.right = nil

    elsif node.left.nil? || node.right.nil?
      child = node.left || node.right
      parent.left == node ? parent.left = child : parent.right = child

    else
      temp_node = node.right
      until temp_node.right.nil? && temp_node.left.nil?
        if !temp_node.left.nil?
          parent = temp_node
          temp_node = temp_node.left
        else
          parent = temp_node
          temp_node = temp_node.right
        end
      end

      node.data = temp_node.data
      parent.right = nil if temp_node.data > parent.data
      parent.left = nil unless temp_node.data > parent.data
    end
    root
  end

  def find(value, node = @root)
    current_node = node
    return nil if current_node.nil?

    until current_node.data == value
      current_node = current_node.right if value > current_node.data
      current_node = current_node.left if value < current_node.data 

      if current_node.left.nil? && current_node.right.nil?   
        puts "Does not exist." if current_node.data != value
        break   
      end
    end
    puts current_node if current_node.data == value
  end

  def level_order(node = @root, queue = [])
    queue.push(node)
    loop do
      break if queue.length == 0

      queue.push(queue[0].left) unless queue[0].left.nil?
      queue.push(queue[0].right) unless queue[0].right.nil?
      yield(queue[0]) if block_given?
      queue.shift
    end
  end

  def preorder(node = @root, &block)
    return if node.nil?

    if block_given?
      yield(node)
    else
      puts node.data
    end
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def inorder(node = @root, &block)
    return if node.nil?

    inorder(node.left, &block)
    if block_given?
      yield(node)
    else
      puts node.data
    end
    inorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return if node.nil?

    postorder(node.left, &block) 
    postorder(node.right, &block)  
    if block_given? 
      yield(node) 
    else 
      puts node.data 
    end
  end 
end

test = Tree.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
test.pretty_print 
test.find(6)
# test.postorder { |elem| puts elem.data * 10 }
