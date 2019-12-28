#Example: mix run proj1.exs 1260 1396

#Time the function with the following command:
#   time mix run proj1.exs 100000 200000


case length(System.argv) do
  3 ->
    [startRange, endRange, heap] = Enum.map(System.argv(), &String.to_integer(&1))
    Vampire.Server.start_link
    Vampire.Server.find_nums(startRange, endRange, heap)
  2 ->
    [startRange, endRange] = Enum.map(System.argv(), &String.to_integer(&1))
    Vampire.Server.start_link
    Vampire.Server.find_nums(startRange, endRange, 1000)
  _ -> IO.puts("Too few / too many arguments. Please supply start and end range (and optionally heap size) as arguments")
end


"""
#Nick Kroeger - Mac OS Mojave - 16GB RAM - CPU 2.5 GHz Intel Core i7
#Run1:
# real    0m44.692s
# user    2m7.027s
# sys     0m2.245s

#Run2:
# real    0m37.194s
# user    2m6.613s
# sys     0m1.850s

#Run3:
# real    0m38.441s
# user    2m7.585s
# sys     0m1.706s

#Run4:
# real    0m37.443s
# user    2m6.519s
# sys     0m1.736s
"""

"""
Marco Pagani - Windows 10 | 16GB RAM | i7, 6 core 12 threads @ 3.7GHz
NOTE: To time these processes, the program was executed through the mingw bash, which seems to have resulted in unexpected user and system time.
By comparing the real time for each of these tests it is readily apparent that there is effective parallelism ocurring
see: https://stackoverflow.com/questions/46705981/why-does-time-report-low-user-system-with-mingw

Number Range Tested: 100,000 - 200,000

Run 1: 1 process (100,000 per process)
real    1m1.126s
user    0m0.000s
sys     0m0.060s
Improvement: n/a

Run 2: 6 processes (16,667 per process)
real    0m19.229s
user    0m0.000s
sys     0m0.030s
Improvement: 3.2x

Run 3: 12 processes (8,334 per process)
real    0m16.542s
user    0m0.015s
sys     0m0.015s
Improvement: 3.8x

Run 4: 100 processes (1,000 per process)
real    0m13.725s
user    0m0.015s
sys     0m0.030s
Improvement: 4.4x

Run 5: 1,000 processes (100 per process)
real    0m14.755s
user    0m0.000s
sys     0m0.015s
Improvement: 4.1x



"""
