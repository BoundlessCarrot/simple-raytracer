def ascii_to_bit_vectors(ascii_art):
    # Split the ASCII art by newlines to get individual rows
    rows = ascii_art.strip().split('\n')

    # Initialize an empty list to store the bit vectors
    bit_vectors = []
    # Iterate over each row
    for row in rows:
        # Skip empty rows
        if not row.strip():
            continue

        # Initialize the bit vector for this row
        bit_vector = 0

        # Iterate over each character in the row
        for i, char in enumerate(row.strip()):
            # Check if the character represents a set bit
            if char == '1':
                bit_vector |= (1 << (len(row.strip()) - i - 1))
        # Append the bit vector to the list
        bit_vectors.append(bit_vector)
    return bit_vectors

# Example usage
# ascii_art = """\
#    /*
#  
#    16                    1    
#    16                    1    
#    231184   111    111   1    
#    18577       1  1   1  1   1
#    18578       1  1   1  1  1 
#    249748   1111  11111  1 1  
#    280600  1   1  1      11   
#    280596  1   1  1      1 1  
#    247570   1111   111   1  1 
#  
#    */"""

# ascii_art = """\
# 11111111 11     11   1111111 11    1
# 11       11     11  11       11   1 
# 11       11     11 11        11  1  
# 11111    11     11 1         11 1   
# 11       11     11 1         111    
# 11       11     11 1         11 1   
# 11       11     11 11        11  1  
# 11       11     11  11       11   1 
# 11         11111     1111111 11    1
#                                      
#  1     1   1111111  11     11        
#   1   1   1       1 11     11        
#    111    1       1 11     11        
#     1     1       1 11     11        
#     1     1       1 11     11        
#     1     1       1 11     11        
#     1     1       1 11     11        
#     1     1       1 11     11        
#     1      1111111    11111          
# """

# ascii_art = """\
# 1     1  1     11111    1           1
# 1     1  1    1         1     1     1
# 1     1      1                1     1
# 1     1  1   1          1  1111111  1
# 1111111  1   1          1     1     1
# 1     1  1   1    1111  1     1     1
# 1     1  1   1       1  1     1     1
# 1     1  1   1       1  1     1      
# 1     1  1    1      1  1     1     1
# 1     1  1     111111   1     1     1
# """

ascii_art = """\
     1   11111   1111111   11111 
     1  1           1     1     1
     1  1           1     1     1
     1  1           1     111111 
     1   11111      1     11     
     1        1     1     1 1    
1    1        1     1     1  1   
1    1        1     1     1   1  
 1111   111111      1     1    1 
"""

bit_vectors = ascii_to_bit_vectors(ascii_art)

# Print the resulting bit vectors
print(f"Bit vector: {bit_vectors}, number of lines: {len(bit_vectors)}, number of columns: {len(ascii_art.strip().split('\n')[0].strip())}")
