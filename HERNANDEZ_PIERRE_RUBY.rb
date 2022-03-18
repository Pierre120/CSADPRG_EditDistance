=begin
********************
Name: Pierre Vincent C. Hernandez
Language: Ruby
Paradigm: Object-Oriented
********************
=end

# Class responsible for solving the edit distance using dynamic programming solution.
class EDSolver
  # Constructor for EDSolver. Initializes the @solved instance
  # variable to false to signify that the newly created EDSolver
  # object hasn't done anything yet and to avoid run-time errors.
  def initialize
    @solved = false
  end

  # Solves the Edit Distance given two input string.
  def solve
    input_strings
    calc_ed
    puts "\nEdit distance: #{min_ed}"
    @solved = true
  end

  # Prints the edit operations. Calls the ```perfrom_ops``` method
  # to print the operations.
  def print_ops
    if @solved == true
      puts 'Operations:'
      min_ed.zero? ? pno_ops : perform_ops
    else
      puts 'Input strings first!'
    end
  end

  # Equivalent to the ```print_ops``` method -- only difference is that
  # it calls the ```perform_ops!``` method for printing the operations.
  def print_ops!
    if @solved == true
      puts 'Operations:'
      min_ed.zero? ? pno_ops : perform_ops!
    else
      puts 'Input strings first!'
    end
  end

  # Prints the Edit Distance cost matrix.
  def _ed_dbg!
    return unless @solved

    print '  ' # 2 space characters
    @string1.chars.each { |char| print " #{char} " } # Print string 1
    print "\n"
    # Print string 2 and edit distance matrix
    @strlen2.times do |row|
      print "#{@string2[row]} "
      @edmatrix[row].each { |cost| print " #{cost} " }
      print "\n"
    end
    print '  ' # 2 space characters
    @edmatrix[@strlen2].each { |cost| print " #{cost} " }
    print "\n"
  end

  private

  # Checks if insert operation should be done.
  def insert?(row, col)
    # min_op(row, col) == insert_op(row, col)
    row < @strlen2 && @edmatrix[row + 1][col] == @edmatrix[row][col].pred
  end

  # Checks if delete operation should be done.
  def delete?(row, col)
    # min_op(row, col) == delete_op(row, col)
    col < @strlen1 && @edmatrix[row][col + 1] == @edmatrix[row][col].pred
  end

  # Checks if replace operation should be done.
  def replace?(row, col)
    # min_op(row, col) == replace_op(row, col)
    @edmatrix[row + 1][col + 1] == @edmatrix[row][col].pred
  end

  # Checks if copy operation should be done.
  def copy?(row, col)
    @string1[col].eql?(@string2[row]) # @string1[col] == @string2[row]
  end

  # Returns the insert cost.
  def insert_op(row, col)
    @edmatrix[row + 1][col] + 1
  end

  # Returns the delete cost.
  def delete_op(row, col)
    @edmatrix[row][col + 1] + 1
  end

  # Returns the replace cost
  def replace_op(row, col)
    return @edmatrix[row + 1][col + 1] + 1 unless copy?(row, col)

    @edmatrix[row + 1][col + 1]
  end

  # Returns the minimum cost among the three operations:
  # insert, delete, and replace.
  def min_op(row, col)
    [insert_op(row, col), delete_op(row, col), replace_op(row, col)].min
  end

  # Prints "No Operations" to inform user that the two strings are equal.
  def pno_ops
    puts 'No Operations'
  end

  # Prints the inserted letter.
  def print_ins(row)
    puts "Insert #{@string2[row]}"
  end

  # Prints the deleted letter.
  def print_del(col)
    puts "Delete #{@string1[col]}"
  end

  # Prints the letter to be replaced and the letter replaced it.
  def print_rep(row, col)
    puts "Replace #{@string1[col]} with #{@string2[row]}"
  end

  # Prints the operations performed using the ***until*** loop.
  def perform_ops(row = 0, col = 0)
    until @edmatrix[row][col].zero?
      if copy?(row, col)
        # Move diagonally
        row += 1
        col += 1
      elsif insert?(row, col)
        print_ins(row) # Print inserted character
        row += 1 # Move down
      elsif delete?(row, col)
        print_del(col) # Print deleted character
        col += 1 # Move to right
      elsif replace?(row, col)
        print_rep(row, col) # Print character replacings
        # Move diagonally
        row += 1
        col += 1
      end
    end
  end

  # Prints the operations performed using ***recursion***.
  def perform_ops!(row = 0, col = 0)
    return unless @edmatrix[row][col].positive?

    if copy?(row, col)
      perform_ops!(row + 1, col + 1) # Move diagonally
    elsif insert?(row, col)
      print_ins(row) # Print inserted character
      perform_ops!(row + 1, col) # Move down
    elsif delete?(row, col)
      print_del(col) # Print deleted character
      perform_ops!(row, col + 1) # Move to right
    elsif replace?(row, col)
      print_rep(row, col) # Print character replacings
      perform_ops!(row + 1, col + 1) # Move diagonally
    end
  end

  # Gets 2 string input from the user to solve its edit distance.
  # It then initializes the edit distance cost matrix depending on
  # the length of both strings.
  def input_strings
    # Input for string 1
    print 'Input string 1 = '
    @string1 = gets.chomp
    # Input for string 2
    print 'Input string 2 = '
    @string2 = gets.chomp
    # Get length of both strings
    getstr_lengths
    # Initialize the edit distance matrix
    init_edmatrix
  end

  # Initializes the edit distance matrix.
  def init_edmatrix
    # @edmatrix[@strlen2 + 1][@strlen1 + 1]
    @edmatrix = Array.new(@strlen2 + 1) { Array.new(@strlen1 + 1) }
    # Initialize last row
    @strlen1.times { |col| @edmatrix[@strlen2][col] = @strlen1 - col }
    # Initialize last column
    @strlen2.times { |row| @edmatrix[row][@strlen1] = @strlen2 - row }
    # Start point (from bottom-right to top-left)
    @edmatrix[@strlen2][@strlen1] = 0
  end

  # Calculates all the possible edit distance costs
  # and edit combinations of 2 given string inputs.
  def calc_ed
    (@strlen2 - 1).downto(0) do |row|
      (@strlen1 - 1).downto(0) do |col|
        @edmatrix[row][col] = min_op(row, col)
      end
    end
  end

  # Gets the length of 2 string inputs.
  def getstr_lengths
    @strlen1 = @string1.length
    @strlen2 = @string2.length
  end

  # Gets the minimum edit distance.
  def min_ed
    @edmatrix[0][0]
  end
end

# Start of the Application
print "\n\n"
ed_obj = EDSolver.new
ed_obj.solve
ed_obj.print_ops
print "\n\n"
