def object_has(obj, fields):
    '''
    Checks if an object has all the fields.
    '''
    for f in fields:
        if f not in obj:
            return False

    return True
