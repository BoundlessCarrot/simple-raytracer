def ascii_to_bit_vectors(ascii_art):
    # Split the ASCII art by newlines to get individual rows
    rows = ascii_art.strip().split('\n')

    # Initialize an empty list to store the bit vectors
    bit_vectors = [0]

    longest_vec = 0

# Iterate over each row
    for row in rows:
        # Skip empty rows
        if not row:
            continue

        if len(row) > longest_vec:
            longest_vec = len(row)

    # Iterate over each row
    for i, row in enumerate(rows):
        # Skip empty rows
        if not row:
            continue

        row_copy = row.replace(' ', '0').replace('1', '1')

        # Pad the row with zeros to make it the same length as the longest row
        if i == 0:
            row_copy = row_copy.ljust(longest_vec, '0')
        elif i == len(rows) - 1:
            row_copy = row_copy.rjust(longest_vec, '0')

        bit_vector = int(row_copy, 2)
        print(f"Row:\t{row}, Bit vector:\t{bit_vector}, Row copy:\t{row_copy}")

        # Append the bit vector to the list
        bit_vectors.append(bit_vector)
    print()
    bit_vectors.append(0)
    bit_vectors.reverse()

    return bit_vectors, longest_vec

# Example usage
# ascii_art = """\
#
#                 1    
#                 1    
#    1111   111   1    
#       1  1   1  1   1
#       1  1   1  1  1 
#    1111  11111  1 1  
#   1   1  1      11   
#   1   1  1      1 1  
#    1111   111   1  1 
#
# """

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

bit_vectors, longest_vec = ascii_to_bit_vectors(ascii_art)
# Print the resulting bit vectors
# longest_vec = len(ascii_art.strip().split('\n')[4])
print(f"Bit vector: {bit_vectors}, number of lines: {len(bit_vectors)}, number of columns: {longest_vec}")
