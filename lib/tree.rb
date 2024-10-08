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
    # puts arr[mid]
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

  def insert(value,root = @root)
    if root.nil?
      root = Node.new(value)
    elsif value < root.data
      root.left = insert(value,root.left)
    elsif value > root.data
      root.right = insert(value,root.right)
    end
    root
  end

  def delete(value, root = @root)
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
    return nil if node.nil?
    return node if node.data == value

    if value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def level_order(node = @root, queue = [])
    queue.push(node)
    loop do
      break if queue.length == 0

      queue.push(queue[0].left) unless queue[0].left.nil?
      queue.push(queue[0].right) unless queue[0].right.nil?
       if block_given? 
        yield(queue[0].data) 
       else 
        puts queue[0].data 
       end
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
    preorder(node.right,&block)

  end

  def inorder(node = @root, result = [], &block)
    return result if node.nil?

    inorder(node.left, result, &block)
    if block_given?
      yield(node)
    else
      result << node.data
    end
    inorder(node.right, result, &block)

    return result unless block_given?
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

  def height(node)
    return -1 if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)   

    [left_height, right_height].max + 1    
  end

  def depth(value, dist = 0, current_node = @root)
    return -1 if current_node.nil?
    return dist if value == current_node.data

    return depth(value, dist + 1, current_node.right) if value > current_node.data

    depth(value, dist + 1, current_node.left) if value < current_node.data
  end 

  def balanced?(node = @root)  
    return true if node.nil? 

    left_height = height(node.left)
    right_height = height(node.right)  
    
    if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
      true
    else
      false
    end
  end 

  def rebalance 
    if !balanced?(@root) 
      temp_arr = inorder 
      @root = build_tree(temp_arr) 
    end
  end
end 

test = Tree.new( (Array.new(15) { rand(1..100) }).sort  )    
# test.rebalance  
test.insert(310) 
test.insert(345) 
test.insert(890) 
test.insert(750) 
test.insert(132) 
test.insert(190) 
test.insert(810) 
test.pretty_print 
puts test.balanced? 
test.rebalance 
test.pretty_print 
puts test.balanced? 
puts test.level_order {|n| puts n*0}
 

