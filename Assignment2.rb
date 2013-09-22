# Assignment 2: Programming in Ruby
# Written by Pattiya Mahapasuthanon
# 09/15/2013
# Github link: https://github.com/pattiyapop/Assignment2

# Part0 - continue from Lab2 Part1 and Part2
# Part3: Rock Paper Scissors
class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

# a
# Some parts of the program are implemented from methods researching in Ruby documentation 
def rps_game_winner(game) 
   raise WrongNumberOfPlayersError unless game.length == 2
   options = [ "R", "S", "P" ]
   game.map {|i| i[1].capitalize}
   p1 = game.first
   p2 = game.last

   raise NoSuchStrategyError unless options.include? p1.last && p2.last
   case [p1.last.downcase, p2.last.downcase]
	when ['p','r'], ['s','p'], ['r','s']
		return p1
        when ['r','r'], ['p','p'], ['s','s']
		return p1
        else
        	return p2
        end
end

# b
def rps_tournament_winner(game)
   if(game.first.is_a?(Array))
   	return rps_game_winner([rps_tournament_winner(game.first), rps_tournament_winner(game.last)])
   end
   return game
end

=begin
print rps_tournament_winner([ ["Armando", "P"], ["Dave", "S"] ])
print rps_tournament_winner([ [ [ ["Armando", "P"], ["Dave", "S"] ], [ ["Richard", "R"], ["Michael", "S"] ],
    ], [ [ ["Allen", "S"], ["Omer", "P"] ], [ ["David E.", "R"], ["Richard X.", "P"] ] ] ])
print rps_tournament_winner([[ ["Armando", "P"], ["Dave", "S"] ], [ ["Richard", "R"],  ["Michael", "S"] ]])
=end

# Part4: Anagrams
def combine_anagrams(words)
   words.group_by {|i| i.chars.sort.join}.values
end


#words = ['cars', 'for', 'potatoes', 'racs', 'four', 'scar', 'creams', 'scream'] 
#print combine_anagrams(words)

# output: [ ["cars", "racs", "scar"],
#           ["four"],
#           ["for"],
#           ["potatoes"],
#           ["creams", "scream"] ]

# Part1 - Classes
# a
class Dessert 
   def initialize(name, calories)
	@name = name
	@calories = calories
   end

   def healthy?
	@calories < 200
   end

   def delicious?
   	true
   end
end

#b
class JellyBean < Dessert
   def initialize(name, calories, flavor)
	@name = name
	@calories = calories
	@flavor = flavor
   end

   def delicious?
	@flavor != "black licorice"
   end
end

=begin
test = Dessert.new("chocolate", 300)
puts test.delicious?
puts test.healthy?
test2 = JellyBean.new("chocolate", 500, "black licorice")
puts test2.delicious?
puts test2.healthy? 
=end

# Part2 - Object Oriented Programming
class Class
   def attr_accessor_with_history(attr_name)
   	attr_name = attr_name.to_s       # make sure it's a string
        attr_reader attr_name            # create the attribute's getter
        attr_reader attr_name+"_history" # create bar_history getter
        class_eval %Q{
		     def #{attr_name}=(attr_value)
		     @#{attr_name}=attr_value
		     if @#{attr_name}_history == nil
  		     @#{attr_name}_history = [nil]
                     end
                     @#{attr_name}_history << attr_value
		     end }
   end
end

class Foo
    attr_accessor_with_history :bar
end

=begin
f = Foo.new 
f.bar = 1
f.bar = 2
p f.bar
p f.bar_history # => if your code works, should be [nil,1,2] 
=end

# Part3 - More OOP
# a
class Numeric
   @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1.0}
   def method_missing(method_id)
   	singular_currency = method_id.to_s.gsub( /s$/, '')
   	if @@currencies.has_key?(singular_currency)
     		self * @@currencies[singular_currency]
   	else
     		super
   	end
   end

   def in(currency)
	singular_currency = currency.to_s.gsub( /s$/, '')
	if @@currencies.has_key?(singular_currency)
		self / @@currencies[singular_currency]
	else
		super
   	end   
   end
end

#puts 5.dollars.in(:euros)
#puts 10.euros.in(:rupees)

#b
class String
   def palindrome?
   	string = self.downcase.gsub(/\W/, '')
	string == string.reverse
   end
end

#puts "foo".palindrome?
#puts "A man, a plan, a canal -- Panama".palindrome?

#c
module Enumerable
   def palindrome?
   	self.to_a == self.to_a.reverse		
   end
end

#puts [1,2,3,2,1].palindrome? 

# Part4 - Blocks
class CartesianProduct
    include Enumerable
    attr_reader :l_enum, :r_enum
    def initialize(l_enum, r_enum)
	@l_enum = l_enum	
	@r_enum = r_enum
    end

    def each
	self.l_enum.each {
	      |l| self.r_enum.each {
		|r| yield [l, r]
	      }
	}
    end
end

#c = CartesianProduct.new([:a,:b], [4,5])
#c.each { |elt| puts elt.inspect }
# [:a, 4]
# [:a, 5]
# [:b, 4]
# [:b, 5]

#c = CartesianProduct.new([:a,:b], [])
#c.each { |elt| puts elt.inspect }
