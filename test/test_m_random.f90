program test_m_random
   use m_random

   implicit none
   integer, parameter  :: dp = kind(0.0d0)
   integer, parameter  :: n_samples = 100*1000*1000
   integer             :: nn, rng_seed
   real(dp)            :: mean, variance
   real(dp), parameter :: pi        = acos(-1.0_dp)
   real(dp)            :: time_start, time_end
   real(dp), allocatable :: rand_results(:)
   type(RNG_state_t) :: rng_state

   allocate(rand_results(n_samples))

   print *, "Testing implementation of m_random.f90"
   print *, "This is just checking whether everything works, and by no means"
   print *, "a test of the 'randomness' of the pseudo random number generator."
   print *, "For these tests, ", n_samples, " values are used"

   call system_clock(count=rng_seed)

   call cpu_time(time_start)
   call random_number(rand_results)
   call cpu_time(time_end)
   mean = sum(rand_results) / n_samples
   variance = sum((rand_results - mean)**2) / n_samples

   print *, ""
   print *, "For uniform random numbers (random_number), the result is:"
   print *, "nanoseconds per number (upper bound)", 1.0e9_dp * (time_end - time_start) / n_samples
   print *, "mean/<mean>", mean/0.5_dp
   print *, "std dev/<std dev>", sqrt(variance)*sqrt(12.0_dp)

   call RNG_set_state(rng_state, (/rng_seed, 1337, 711337, 623454235/))

   call cpu_time(time_start)
   do nn = 1, n_samples
      rand_results(nn) = RNG_U01(rng_state)
   end do
   call cpu_time(time_end)
   mean = sum(rand_results) / n_samples
   variance = sum((rand_results - mean)**2) / n_samples

   print *, ""
   print *, "For uniform random numbers (random_number), the result is:"
   print *, "nanoseconds per number (upper bound)", 1.0e9_dp * (time_end - time_start) / n_samples
   print *, "mean/<mean>", mean/0.5_dp
   print *, "std dev/<std dev>", sqrt(variance)*sqrt(12.0_dp)

   ! call cpu_time(time_start)
   ! do nn = 1, n_samples
   !    rand_results(nn) = RNG_normal()
   ! end do
   ! call cpu_time(time_end)
   ! rand_results = rand_results + 1
   ! mean = sum(rand_results) / n_samples
   ! variance = sum((rand_results - mean)**2) / n_samples

   ! print *, ""
   ! print *, "For normal/Gaussian random numbers, the result is:"
   ! print *, "nanoseconds per number (upper bound)", 1.0e9_dp * (time_end - time_start) / n_samples
   ! print *, "mean/<mean>", mean/1.0_dp ! Above we add one to RNG_normal()
   ! print *, "std dev/<std dev>", sqrt(variance)

   ! call cpu_time(time_start)
   ! do nn = 1, n_samples
   !    rand_results(nn) = RNG_poisson(pi)
   ! end do
   ! call cpu_time(time_end)
   ! mean = sum(rand_results) / n_samples
   ! variance = sum((rand_results - mean)**2) / n_samples

   ! print *, ""
   ! print *, "For Poisson random numbers, the result is:"
   ! print *, "nanoseconds per number (upper bound)", 1.0e9_dp * (time_end - time_start) / n_samples
   ! print *, "mean/<mean>", mean/pi ! Above we add one to RNG_normal()
   ! print *, "std dev/<std dev>", sqrt(variance/pi)

end program test_m_random