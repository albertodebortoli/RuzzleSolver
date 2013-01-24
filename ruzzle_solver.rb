#!/usr/bin/env ruby
require 'matrix'
require "./ukkonen.rb"

module RuzzleSolver
  
  @@max_deep = 6
  
  def find_neighbors(m, coords, path) 
    # 3 5 8
    # 2 n 7
    # 1 4 6
    a = Array.new
    i = coords[0]
    j = coords[1]
  
    indexes = [[i-1,j-1], [i-1,j], [i-1,j+1], [i,j-1], [i,j+1], [i+1,j-1], [i+1,j], [i+1,j+1]]
  
    indexes.each do |i, j|
      a.push [m[i,j], i, j] if m[i,j] && i>=0 && i<=3 && j>=0 && j<=3 && !path.include?([i,j])  
    end
  
    # something like ["S", 3, 2] (char, x, y)
    return a
  end

  def recursive_finding(b, coords, acc, tree, matches, path)
    neighbor_letters = find_neighbors(b, coords, path)
    #puts neighbor_letters.inspect
    neighbor_letters.each do |l, i, j|
      new_path = Array.new(path)
      new_path.push([i,j])
      s = acc + l
      if tree.contains?(" " + s + " ") && !matches.include?(s)
        puts s
        matches.push(s)
      end
      recursive_finding(b, [i, j], s, tree, matches, new_path) if s.length < @@max_deep
    end
  end

  def run(filename)
    puts "*** RUZZLE SOLVER ***"
    
    words=%w{}
    File.open(filename).each do |line|
      words.push line.chomp
    end
    
    # space to include the last word, since the search in the tree is for " <word> "
    words_joined = " " + words.join(" ") + " " 
    
    # time consuming (creates the suffix tree)
    print "...creating the indexed suffix tree using #{filename}..."
    tree = SuffixTree.new(words_joined)
    puts " Ready to go!"
    
    # example
    # input = "solecobraloratui".upcase
    # please note that 19 is the max length of a string found in italian Ruzzle dictionary
    # brute force searching for long string may take a long time 
    puts "Insert the max word length to search for:"
    @@max_deep = gets.chomp.to_i

    puts "Insert the 16 letters and press enter:"
    input = gets.chomp.upcase
    
    b = Matrix[
      [input[0], input[1], input[2], input[3]],
      [input[4], input[5], input[6], input[7]],
      [input[8], input[9], input[10], input[11]],
      [input[12], input[13], input[14], input[15]]
    ]
    
    matches = Array.new
    
    (0...input.length).to_a.each do |i|
      coords = i/4, i%4
      s = b[coords[0], coords[1]]
      path = [[coords[0], coords[1]]]
      recursive_finding(b, coords, s, tree, matches, path)
    end
  end
  
end
