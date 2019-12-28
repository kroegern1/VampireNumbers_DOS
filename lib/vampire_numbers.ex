
defmodule Vampire.Server do
  use GenServer

  ### Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :vamp_nums)
  end

  def find_nums(first, last, heapSize) do
    GenServer.call(:vamp_nums, {first, last, heapSize}, 100000)
  end

  ### Server
  def init(state) do
    {:ok, state}
    Supervisor.start_link([{Task.Supervisor, name: Vamp_nums}], strategy: :one_for_one)
  end

  def handle_call({first, last, heapSize}, _from, state) do
    VampireSupervisor.run(first, last, heapSize)
    {:reply, state, state}
  end


end



defmodule VampireSupervisor do
  def run(startRange, endRange, heap_size \\ 0) when heap_size >= 0 do
    # IO.puts "in run of VampireSupervisor"
    case heap_size do
      0 -> run(startRange, endRange, div(endRange - startRange, 8), 0)
      _ -> run(startRange, endRange, heap_size, 0)
    end
  end

  defp run(startRange, endRange, heap_size, worker_count) do
    heap = startRange + heap_size

    cond do
      heap < endRange ->
        spawn(VampireWorker, :find_nums, [startRange, heap, self()])
        run(startRange + heap_size + 1, endRange, heap_size, worker_count + 1)

      heap >= endRange ->
        spawn(VampireWorker, :find_nums, [startRange, heap, self()])
        collect_results([], 0, worker_count + 1)
    end
  end

  defp collect_results(vnums, received, workers) when received < workers do
    receive do
      {:ok, num} ->
        collect_results([num | vnums], received + 1, workers)
    end
  end

  defp collect_results(vnums, _received, _workers) do
    print_results(vnums)
  end

  defp print_results(list) do
    results = List.flatten(list) |> Enum.sort(&(elem(&1, 0) < elem(&2, 0)))

    Enum.each(results, fn pair ->
      {key, fangs} = pair
      IO.write("#{key} ")

      Enum.each(fangs, fn fang ->
        IO.write(fang |> Tuple.to_list() |> Enum.join(" "))
        IO.write(" ")
      end)

      IO.puts("")
    end)
  end
end

defmodule VampireWorker do
  @moduledoc """
  Calls VampireCalc every time for each number
  in the range to search for

  """

  def find_nums(first, last, parent) do
    find_nums(first, last, [], parent)
  end

  defp find_nums(first, last, list, parent) when first <= last do
    {found, number, vnums} = VampireCalc.find_fangs(first)

    case found do
      :ok -> find_nums(first + 1, last, [{number, vnums} | list], parent)
      :not_found -> find_nums(first + 1, last, list, parent)
    end
  end

  defp find_nums(_first, _last, list, parent) do
    send(parent, {:ok, list})
    # IO.inspect(list)
  end

end
