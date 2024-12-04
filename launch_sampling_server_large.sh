# Check if the directory does not exist
if [ ! -d "logs" ]; then
    # Create the directory
    mkdir "logs"
    echo "Directory 'logs' created."
fi

check_success() {
    local file=$1
    local message="Started server process"
    # Tail the log file and grep for success message, exit when found
    tail -f "$file" | grep -q "$message"
    echo "Server at $file has started successfully."
}

# Accessing the first
server_engine="$1"

echo "Server Engine is : $server_engine"

get_gpu_count() {
    echo $(nvidia-smi -L | wc -l)
}

CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 python -u -m vllm.entrypoints.openai.api_server \
    --host 0.0.0.0 \
    --model $server_engine \
    --port 8020 \
    --tensor-parallel-size 8 \
    --load-format auto \
    --dtype float16 \
    --api-key token-abc123 \
    --download-dir ./download_dir > logs/server_0.log 2>&1 &
sleep 1
# Start monitoring each server log
check_success "logs/server_0.log" &
pid_array+=($!)  # Save the PID of the check_success process


# Wait only for the check_success processes
for pid in "${pid_array[@]}"; do
    wait $pid
done

