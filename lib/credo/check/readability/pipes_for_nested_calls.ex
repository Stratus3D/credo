defmodule Credo.Check.Readability.PipesForNestedCalls do
  @moduledoc """
  Checks that all nested function calls that can be pipelines are pipelines.

  Like all `Readability` issues, this one is not a technical concern.
  But you can improve the odds of others reading and liking your code by making
  it easier to follow.
  """

  @explanation [check: @moduledoc]

  use Credo.Check, base_priority: :low

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end
end
