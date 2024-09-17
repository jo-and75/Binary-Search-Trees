class Node
  attr_accessor :data, :left, :right

  def initialize(mid)
    @data = mid
    @left = nil
    @right = nil
  end
end
