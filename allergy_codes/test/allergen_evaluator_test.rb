require "minitest/autorun"
require "minitest/pride"
require './lib/allergen_evaluator'
require "pry"

class AllergenEvaluatorTest < Minitest::Test

  def test_check_peanuts_is_returned_for_score_of_2
    evaluator = AllergenEvaluator.new
    allergens = evaluator.assess_allergy_score(2)

    assert_equal ["peanuts"], allergens
  end

  def test_return_eggs_and_peanuts_for_score_of_3
    evaluator = AllergenEvaluator.new
    allergens = evaluator.assess_allergy_score(3)
    included = allergens.include?("eggs") && allergens.include?("peanuts")

    assert included
  end

  def test_combined_score_returns_highest_code_less_than_score
    evaluator = AllergenEvaluator.new

    refute evaluator.allergen_codes.include?("8")

    evaluator.calculate_combined_score(9)

    assert evaluator.allergen_codes.include?("8")
    assert evaluator.allergen_codes.include?("1")
  end

  def test_calculate_combined_score_19
    evaluator = AllergenEvaluator.new

    refute evaluator.allergen_codes.include?("16")

    evaluator.calculate_combined_score(19)

    assert evaluator.allergen_codes.include?("16")
    assert evaluator.allergen_codes.include?("1")
    assert evaluator.allergen_codes.include?("2")
  end

  def test_calculate_combined_score_39
    evaluator = AllergenEvaluator.new

    refute evaluator.allergen_codes.include?("32")

    evaluator.calculate_combined_score(39)

    assert evaluator.allergen_codes.include?("32")
    assert evaluator.allergen_codes.include?("4")
    assert evaluator.allergen_codes.include?("2")
    assert evaluator.allergen_codes.include?("1")
  end

  def test_allergy_score_returns_two_allergens
    evaluator = AllergenEvaluator.new

    allergens = evaluator.assess_allergy_score(9)
    expected_allergens = ["eggs", "strawberries"]
    all_here = allergens.all? do |allergen|
      expected_allergens.include?(allergen)
    end

    assert all_here
  end

  def test_allergy_score_returns_three_allergens
    evaluator = AllergenEvaluator.new

    allergens = evaluator.assess_allergy_score(19)
    expected_allergens = ["tomatoes", "eggs", "peanuts"]
    all_here = allergens.all? do |allergen|
      expected_allergens.include?(allergen)
    end

    assert all_here
  end

  def test_allergy_score_returns_four_allergens
    evaluator = AllergenEvaluator.new

    allergens = evaluator.assess_allergy_score(39)
    expected_allergens = ["chocolate", "shellfish", "peanuts", "eggs"]
    all_here = allergens.all? do |allergen|
      expected_allergens.include?(allergen)
    end

    assert all_here
  end

  def test_double_check_math_prints_and_returns_string
    evaluator = AllergenEvaluator.new
    evaluator.calculate_combined_score(9)
    assert_equal "You got it!", evaluator.double_check_math(9)
  end

  def test_double_check_math_returns_nil_for_incomplete_math
    evaluator = AllergenEvaluator.new
    evaluator.calculate_combined_score(11)

    assert_nil   evaluator.double_check_math(9)
  end

  def test_add_allergens_by_code_converts_allergy_codes_to_allergens
    evaluator = AllergenEvaluator.new
    evaluator.calculate_combined_score(11)
    expected_codes = ["8", "2", "1"]
    all_here =  evaluator.allergen_codes.all? do |code|
       expected_codes.include?(code)
     end

    assert all_here
    assert evaluator.allergens.empty?

    evaluator.add_allergens_by_code
    
    refute evaluator.allergens.empty?
  end


end
