import yaml
import argparse
import os


def add_model_api(file_path, model_name, model_path, parallel):
    # Check if the YAML file exists
    assert os.path.exists(file_path), "api config file does not exist"
    with open(file_path, 'r') as f:
        yaml_data = yaml.safe_load(f) or {}

    # Create a new model entry
    new_model = {
        "model_name": model_path,
        "endpoints": [
            {
            "api_base": "http://localhost:8020/v1/",
            "api_key": "token-abc123"
            }
        ],
        "api_type": "openai",
        "parallel": parallel
    }

    # Add the new model to the YAML data
    yaml_data[model_name] = new_model

    # Save the updated YAML data back to the file
    with open(file_path, 'w') as f:
        yaml.dump(yaml_data, f, default_flow_style=False)
    
    print(f"Model '{model_name}' added successfully to {file_path}")


def update_model_list(file_path, model_name):
    # Check if the YAML file exists
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            yaml_data = yaml.safe_load(f) or {}
    else:
        yaml_data = {}

    # Create a new model entry
    yaml_data["model_list"] = [model_name]

    # Save the updated YAML data back to the file
    with open(file_path, 'w') as f:
        yaml.dump(yaml_data, f, default_flow_style=False)
    
    print(f"Model '{model_name}' added successfully to {file_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Add a new model to the YAML file.")
    # Define named arguments
    parser.add_argument("--model_name", required=True, help="Name of the model to add")
    parser.add_argument("--model_path", required=True, help="Path or identifier for the model")
    parser.add_argument("--parallel", required=True, type=int, help="Number of parallel connections")
    
    args = parser.parse_args()
    api_path = os.path.join("config", "api_config.yaml")
    gen_path = os.path.join("config", "gen_answer_config.yaml")
    judge_path = os.path.join("config", "judge_config.yaml")

    
    add_model_api(api_path, args.model_name, args.model_path, args.parallel)
    update_model_list(gen_path, args.model_name)
    update_model_list(judge_path, args.model_name)



