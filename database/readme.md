# the database
## run the folowing command to update
open a new terminal, type
```
cd database/
python .generate_directory_index.py -o .dir-list.html -r
```
and for future reference, here's the help:
```
usage: .generate_directory_index.py [-h] [--filter FILTER] [--output-file filename] [--recursive] [--include-hidden] [--verbose]
                                    [top_dir]

DESCRIPTION: Generate directory index files (recursive is OFF by default). Start from current dir or from folder passed as first
positional argument. Optionally filter by file types with --filter "*.py".

positional arguments:
  top_dir               top folder from which to start generating indexes, use current folder if not specified

options:
  -h, --help            show this help message and exit
  --filter FILTER, -f FILTER
                        only include files matching glob
  --output-file filename, -o filename
                        Custom output file, by default "index.html"
  --recursive, -r       recursively process nested dirs (FALSE by default)
  --include-hidden, -i  include dot hidden files (FALSE by default)
  --verbose, -v         ***WARNING: can take longer time with complex file tree structures on slow terminals*** verbosely list every
                        processed file
```
