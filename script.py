# script.py
import pandas as pd
import json

def process_data():
    data = {'Name': ['John', 'Anna', 'Peter'], 'Age': [23, 21, 29]}
    df = pd.DataFrame(data)
    # Convert DataFrame to JSON
    return df.to_dict()

if __name__ == '__main__':
    result = process_data()
    # Print the result as a JSON string to stdout
    print(json.dumps(result))
