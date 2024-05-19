# rbx-deflate
 A compression library for Roblox
 
## Motivation
The DEFLATE algorithm is a widely used compression algorithm that is used in many file formats, such as PNG and ZIP. It is a lossless compression algorithm, meaning that the original data can be perfectly reconstructed from the compressed data.

This library is slightly modified from the original implementation by Mark Adler and Jean-loup Gailly's zlib library, as this library uses a variation of the LZW algorithm created by 1waffle1 and fixed/optimized by me.

## Usage
The library is simple to use.

`Deflate.encode(string)` will compress a string and return the compressed data.

`Deflate.decode(string)` will decompress a string and return the decompressed data.

Note that because of the nature of any compression algorithm, the compressed data may be larger than the original data. This is especially true for small strings.