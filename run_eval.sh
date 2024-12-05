#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: bash run_eval.sh <model_name> <model_path> <parallel>"
    exit 1
fi

# Assign arguments to variables
MODEL_NAME="$1"
MODEL_PATH="$2"
PARALLEL="$3"

# Print out the provided arguments for confirmation
echo "Running evaluation with the following parameters:"
echo "Model Name: $MODEL_NAME"
echo "Model Path: $MODEL_PATH"
echo "Parallel: $PARALLEL"


# Launch vllm server
echo "Launch VLLM serving"
bash launch_sampling_server_large.sh $MODEL_PATH

# Example command using these arguments (replace with your actual command)
echo "Executing evaluation script..." 

# update the yaml files with the passed configs
python update_yaml.py --model_name "$MODEL_NAME" --model_path "$MODEL_PATH" --parallel "$PARALLEL"

# run the eval process
python gen_answer.py
python gen_judgment.py

# show eval results
python show_result.py 

# Save evaluation results to the specified location
SAVE_DIR="/new_data/gx/arena_hard_results/arena-hard-v0.1/model_judgment/gpt-4-1106-preview"
cp judgment_output.jsonl "$SAVE_DIR/$MODEL_NAME.jsonl"
