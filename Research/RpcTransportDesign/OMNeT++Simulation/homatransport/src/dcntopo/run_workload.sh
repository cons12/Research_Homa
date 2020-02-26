#!/bin/bash

# import configurations (UNSAFE!)
if [ ! $# -eq 0 ]; then
	config_file="$1"
	source "$config_file"
else
	echo "usage: ./run_pipeline <config-file>.conf";
	exit 1;
fi

# script start-time
start=$(date +%s)

# function to wait for a bunch of jobs to finish
synchronization_barrier () {
	arr=("$@")
	for pid in "${arr[@]}"; do
		wait "$pid"
	done
}

# redirect stdout and stderr to logfile
logfile="./run_pipeline-${date}.log"
echo "-I- run_pipeline: running..."
echo "-I- run_pipeline: to check status, run \"tail -f ${logfile}\""
exec > "$logfile" 2>&1

# print run configurations to config file for reference
configfile="./run_pipeline-${date}-config.txt"
echo "exp:       	(${exp[*]})" 			>> "$configfile"
echo "alphas:       	(${alphas[*]})" 		>> "$configfile"
echo "workloads:           (${workloads[*]})"                 >> "$configfile"

# initialize pids arrays for new jobs, and zero proccount
sim_pids=()
load_pids=()
plot_pids=()
proccount=0


# enter ns2 directory to run simulations
pushd $ns2

# Simulations With pbs aware
for W in "${workloads[@]}";
do
	for A in "${alphas[@]}";
	do
		proccount=$(($proccount+1))
		if [ $proccount == $processors ]; then
			synchronization_barrier "${sim_pids[@]}"
			sim_pids=()
			proccount=1
		fi
		args="  -u Cmdenv"
		args+=" -c $W"
		args+=" --r_alpha=$A"
		args+=" --r_mode=aware"
		args+=" -r 15"
		args+=" --output-vector-file=\"$(W)-15-aware-$(A).vec\""
		args+=" --output-scalar-file=\"$(W)-15-aware-$(A).sca\"" 
		args+=" -n ..:../../simulations:../../../inet/examples:../../../inet/src -l ../../../inet/src/INET homaTransportConfig_pbs.ini"
		echo "Running Sim with args: $args"
		../homatransport "$args" & sim_pids+=("$!")
	done
done

# Simulations with HOMA
for W in "${workloads[@]}";
do
	proccount=$(($proccount+1))
        if [ $proccount == $processors ]; then
                synchronization_barrier "${sim_pids[@]}"
                sim_pids=()
                proccount=1
        fi
	args="  -u Cmdenv"
        args+=" -c $W"
        args+=" --r_alpha=0"
        args+=" --r_mode=homa"
        args+=" -r 15"
	args+=" --output-vector-file=\"$(W)-15-homa-$(A).vec\""
        args+=" --output-scalar-file=\"$(W)-15-homa-$(A).sca\""
        args+=" -n ..:../../simulations:../../../inet/examples:../../../inet/src -l ../../../inet/src/INET homaTransportConfig_pbs.ini"
        echo "Running Sim with args: $args"
        ../homatransport "$args" & sim_pids+=("$!")
        done
done

# Simulations With pbs blind
for W in "${workloads[@]}";
do
        for A in "${alphas[@]}";
        do
                proccount=$(($proccount+1))
                if [ $proccount == $processors ]; then
                        synchronization_barrier "${sim_pids[@]}"
                        sim_pids=()
                        proccount=1
                fi
                args="  -u Cmdenv"
                args+=" -c $W"
                args+=" --r_alpha=$A"
                args+=" --r_mode=blind"
                args+=" -r 15"
                args+=" --output-vector-file=\"$(W)-15-blind-$(A).vec\""
                args+=" --output-scalar-file=\"$(W)-15-blind-$(A).sca\"" 
		args+=" -n ..:../../simulations:../../../inet/examples:../../../inet/src -l ../../../inet/src/INET homaTransportConfig_pbs.ini"
                echo "Running Sim with args: $args"
                ../homatransport "$args" & sim_pids+=("$!")
        done
done


# wait for simulations to complete
echo "-I- run_pipeline: simulations deployed..." > /dev/tty
echo "-I- run_pipeline: simulations deployed..."
synchronization_barrier "${sim_pids[@]}"
sim_finish=$(date +%s)
sim_runtime=$((sim_finish-start))
echo "-I- run_pipeline: simulations completed in $sim_runtime (s)." > /dev/tty
echo "-I- run_pipeline: simulations completed in $sim_runtime (s)."
	
# move back into original directory to run graph-gen scripts
popd
