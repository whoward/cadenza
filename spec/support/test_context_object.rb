
# frozen_string_literal: true

class TestContextObject < Cadenza::ContextObject
  def public_visibility_method
    123
  end

  protected

  def protected_visibility_method
    123
  end

  private

  def before_method(method); end

  def after_method(method); end

  def missing_context_method(method); end

  def private_visibility_method
    123
  end
end
