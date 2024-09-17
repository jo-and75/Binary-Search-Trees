require_relative 'node' 

class Tree 
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
end