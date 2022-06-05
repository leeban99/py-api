from typing import Union
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Operations": "Sum"}

@app.get("/items/{operation}")
def read_item(operation: str, q: Union[str, None] = None):
    list_of_numbers = q.split(',')  
    sum_of_numbers = 0
    for element in list_of_numbers:
        sum_of_numbers = sum_of_numbers + int(element)
    return {"operation": operation, "Array of Numbers": q , "result": sum_of_numbers}
