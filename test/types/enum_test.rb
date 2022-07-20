require "test_helper"

class EnumTest < ActiveSupport::TestCase
  setup { @enum = Kredis.enum "myenum", values: %w[ one two three ], default: "one" }

  test "default" do
    assert_equal "one", @enum.value
  end

  test "default via proc" do
    @enum = Kredis.enum "myenum", values: %w[ one two three ], default: ->() { "two" }
    assert_equal "two", @enum.value
  end

  test "does not set default for invalid option" do
    @enum = Kredis.enum "myenum", values: %w[ one two three ], default: ->() { "four" }
    assert_nil @enum.value
  end

  test "predicates" do
    assert @enum.one?

    @enum.value = "two"
    assert @enum.two?

    assert_not @enum.three?

    @enum.three!
    assert @enum.three?

    assert_not @enum.two?
  end

  test "validated value" do
    assert @enum.one?

    @enum.value = "nonesense"
    assert @enum.one?
  end

  test "reset" do
    @enum.value = "two"
    assert @enum.two?

    @enum.reset
    assert @enum.one?
  end

  test "exists?" do
    assert_not @enum.exists?

    @enum.value = "one"
    assert @enum.exists?
  end
end
