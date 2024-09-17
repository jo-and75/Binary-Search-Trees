require_relative 'node' 

class Tree 
  def initialize(entry)
    @arr = entry.uniq
    @root = build_tree(@arr)
  end

end