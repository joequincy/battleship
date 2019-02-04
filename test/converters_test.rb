require './test/test_helper'

class ConvertersTest < Minitest::Test
  def test_integer_can_convert_self_to_words
    assert_equal "fifty-five", 55.to_words

    assert_equal "one thousand three hundred eighty-seven", 1387.to_words
  end
  def test_integer_can_convert_self_to_row_letters
    assert_equal "C", 3.to_row_letters

    assert_equal "AB", 28.to_row_letters

    assert_equal "BA", 53.to_row_letters
  end

  def test_string_can_convert_self_to_row_num
    assert_equal 3, "C".to_row_num

    assert_equal 28, "AB".to_row_num

    assert_equal 53, "BA".to_row_num
  end

  def test_string_can_split_self_to_coordinate_address_components
    a = "A1".split_coordinate
    b = "AB2".split_coordinate
    c = "C34".split_coordinate
    assert_equal "A", a[:row]
    assert_equal 1, a[:column]

    assert_equal "AB", b[:row]
    assert_equal 2, b[:column]

    assert_equal "C", c[:row]
    assert_equal 34, c[:column]
  end
end
