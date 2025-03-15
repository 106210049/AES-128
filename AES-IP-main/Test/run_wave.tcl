database -open waves -into waves.shm -default
probe -create aes_tb -shm -all -depth all

run
database -close waves
exit

