def retrieve_value_from_nested_object(obj, key):
    # Split the key into a list of nested keys
    keys_list = key.split('/')
    # Iterate through the keys to access nested objects
    nested_object = obj
    for nested_key in keys_list:
        # Check if the nested key exists in the current object
        if nested_key in nested_object:
            # Update the nested object to the next level
            nested_object = nested_object[nested_key]
        else:
            # If any of the keys in the chain doesn't exist, return None
            return None
    # Return the value at the final nested level
    return nested_object

# Example usage:
object1 = {"a": {"b": {"c": "d"}}}
key1 = 'a/b/c'
print(retrieve_value_from_nested_object(object1, key1))  # Output: "d"

object2 = {"x": {"y": {"z": "a"}}}
key2 = 'x/y/z'
print(retrieve_value_from_nested_object(object2, key2))  # Output: "a"
