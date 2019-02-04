class Integer
  def to_words(num = self)
    words = ""
    if num == 0
      return words
    elsif num > 999_999_999_999
      return "Way too many"
    end
    bases = {
      1_000_000_000 => "billion",
      1_000_000 => "million",
      1_000 => "thousand",
      100 => "hundred",
      90 => "ninety",
      80 => "eighty",
      70 => "seventy",
      60 => "sixty",
      50 => "fifty",
      40 => "forty",
      30 => "thirty",
      20 => "twenty",
      19 => "nineteen",
      18 => "eighteen",
      17 => "seventeen",
      16 => "sixteen",
      15 => "fifteen",
      14 => "fourteen",
      13 => "thirteen",
      12 => "twelve",
      11 => "eleven",
      10 => "ten",
      9 => "nine",
      8 => "eight",
      7 => "seven",
      6 => "six",
      5 => "five",
      4 => "four",
      3 => "three",
      2 => "two",
      1 => "one"
    }
    bases.each do |int, word|
      if num >= 100 && num >= int
        # binding.pry
        #numbers greater than 100 have a prefix (one) and a suffix (hundred)
        return to_words(num / int) + " #{word} " + to_words(num % int)
      elsif num % int == 0
        #matches the word exactly
        return "#{word}"
      elsif num / int > 0 && num < 100
        #divisible by the word, but not exactly, so deal with the remainder
        return "#{word}-" + to_words(num % int)
      end
    end
  end

  def to_row_letters(int = self)
    if int > 26
      to_row_letters(int / 26) + to_row_letters(int % 26)
    else
      (int + 64).chr
    end
  end
end

class String
  def to_row_num
    sum = 0
    parts = self.split("")
    parts.map! do |letter|
      letter.ord - 64
    end.reverse!
    parts.each_index do |i|
      sum += parts[i] * 26**i
    end
    return sum
  end

  def split_coordinate
    output = {}
    output[:row] = self.match(/^[A-Z]+/)[0]
    output[:column] = self.match(/[0-9]+$/)[0].to_i
    return output
  end
end
