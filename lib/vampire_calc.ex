defmodule VampireCalc do
  @moduledoc """
  Functions for calculating the fangs, if any, of a number
  """

  @doc """
  Calculates the fangs, if any, of an integer which meets the requirements of being a vampire number.

  Returns :ok when a valid pair of fangs are found, and :not_found otherwise.

  ## Examples

      iex> VampireCalc.find_fangs(1260)
      1260 21 60
  """
  # @spec find_fangs(integer) :: {atom, integer, list}

  def find_fangs(number) when number > 100 do
    if Integer.to_charlist(number) |> length |> rem(2) == 0 do
      results =
        permute(Integer.digits(number))
        |> gen_fangs(Integer.digits(number))
        |> test_fangs(number)

      case results do
        [] -> {:not_found, 0, []}
        _ -> {:ok, number, results}
      end
    else
      {:not_found, 0, []}
    end
  end

  @spec find_fangs(integer) :: {atom, integer, list}
  def find_fangs(_number) do
    {:not_found, 0, []}
  end


  defp permute([]), do: [[]]

  defp permute(digits) do
    for head <- digits, rest <- permute(digits -- [head]), do: [head | rest]
  end


  defp gen_fangs(perms, size) do
    gen_fangs(perms, size, [])
  end

  defp gen_fangs([], _length, result) do
    Enum.uniq(result)
  end

  defp gen_fangs([head | rest], size, results) do
    pair = Enum.split(head, div(length(size), 2))
    {x,y} = {Integer.undigits(elem(pair, 0)), Integer.undigits(elem(pair, 1))}
    cond do
      x > y -> gen_fangs(rest, size, [{y,x} | results])
      true -> gen_fangs(rest, size, [{x,y} | results])
    end

  end


  defp test_fangs(fangs, number) do
    test_fangs(number, fangs, [])
  end

  defp test_fangs(_number, [], results) do
    results
  end

  defp test_fangs(number, [head | rest], results) do
    # get elements of tuple
    {x, y} = head
    # get length of elements
    {xl, yl} = {Integer.to_charlist(x) |> length, Integer.to_charlist(y) |> length}
    # check if both end in 0
    tens = rem(x, 10) == 0 and rem(y, 10) == 0

    cond do
      number == x * y and xl == yl and not tens ->
        test_fangs(number, rest, [head | results])

      true ->
        test_fangs(number, rest, results)
    end
  end
end
