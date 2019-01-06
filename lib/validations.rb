# frozen_string_literal: true

# Encapsulates logic used to ensure that instance parameters and method arguments are valid.
class Validations
  def self.ensure_argument(condition, message)
    raise ArgumentError, message unless condition
  end

  def self.ensure_is_a(var, property, klass, message: nil)
    return if var.is_a?(klass)

    message ||= "The #{caller_class(caller(1..1).first)} #{property} must be a #{klass}."
    raise ArgumentError, message
  end

  def self.ensure_is_an_array_of(var, property, klass, allow_empty: true, message: nil)
    empty_and_ok = allow_empty && var.empty?
    return if var.is_a?(Array) && (empty_and_ok || var.map(&:class).uniq == [klass])

    message ||= "The #{caller_class(caller(1..1).first)} #{property} must be an array of #{klass}s."
    raise ArgumentError, message
  end

  def self.ensure_positive_integer(var, property, message: nil)
    return if var.is_a?(Integer) && var.positive?

    message ||= "#{class_string(caller)}'s #{property} must be a positive integer."
    raise ArgumentError, message
  end

  def self.ensure_positive_number(var, property, message: nil)
    return if var.is_a?(Numeric) && var.positive?

    message ||= "#{class_string(caller)}'s #{property} must be a positive number."
    raise ArgumentError, message
  end

  def self.ensure_non_negative_number(var, property, message: nil)
    return if var.is_a?(Numeric) && !var.negative?

    message ||= "#{class_string(caller)}'s #{property} must be a non-negative number."
    raise ArgumentError, message
  end

  def self.caller_class(caller)
    caller.match(%r{/(\w+)\.rb})[1].split('_').collect(&:capitalize).join
  end

  # 'A ClassName' or 'An OtherClassName'
  def self.class_string(caller)
    class_name = caller_class(caller.first)
    "#{indefinite_article_for(class_name)} #{class_name}"
  end

  def self.indefinite_article_for(word)
    %w[a e i o u].include?(word[0].downcase) ? 'An' : 'A'
  end
end
