# Docs

```
bytes memory bts = "abcdefg";


/* Create Slice */

// Creating a slice from bytes.
Slice memory slice = bts.slice(); 

// Creating a slice starting at index 2.
Slice memory slice = bts.slice(2); // "cdefg"

// Creating a slice starting at index -2.
Slice memory slice = bts.slice(-2); // "fg"

// Creating a slice starting at index 2 and ending at index -2.
Slice memory slice = bts.slice(uint256(-2)); // "cde"

```
