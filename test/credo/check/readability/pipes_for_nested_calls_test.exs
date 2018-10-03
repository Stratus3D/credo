defmodule Credo.Check.Readability.PipesForNestedCallsTest do
  use Credo.TestHelper

  @described_check Credo.Check.Readability.PipesForNestedCalls

  test "it should NOT report expected code" do
    """
    defmodule CredoSampleModule do
      def foobarlist do
        :foo
        |> bar_list()
        |> baz_list()
      end

      def bar_list(foo) do
        [foo, :bar]
      end

      def baz_list(list) do
        list ++ [:baz]
      end
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should NOT report singly nested function calls" do
    """
    defmodule CredoSampleModule do
      def foo do
        baz_list(bar_list(:foo))
      end

      def bar_list(foo) do
        [foo, :bar]
      end

      def baz_list(list) do
        list ++ [:baz]
      end
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should NOT report nested function calls that are not for the first argument" do
    """
    defmodule CredoSampleModule do
      def foo do
        baz_list(:baz, List.to_string(bar_list(:foo)))
      end

      def bar_list(foo) do
        [foo, :bar]
      end

      def baz_list(baz, list) do
        list ++ [baz]
      end
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should report a single violation" do
    """
    defmodule CredoSampleModule do
      def foobar_string do
        List.to_string(baz_list(bar_list(:foo)))
      end

      def bar_list(foo) do
        [foo, :bar]
      end

      def baz_list(list) do
        list ++ [:baz]
      end
    end
    """
    |> to_source_file()
    |> assert_issue(@described_check)
  end

  test "it should report multiple violations" do
    """
    defmodule CredoSampleModule do
      def foobar_string do
        List.to_string(baz_list(bar_list(:foo)))
      end

      def foo_string do
        List.to_string(baz_list(bar_list(:foo)))
      end

      def bar_list(foo) do
        [foo, :bar]
      end

      def baz_list(list) do
        list ++ [:baz]
      end
    end
    """
    |> to_source_file()
    |> assert_issues(@described_check)
  end
end
