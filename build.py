import os
import shutil
import json

from vyper import compiler

FORMATS = {'abi': 'json', 'bytecode': 'txt', 'bytecode_runtime': 'txt'}
ROOT_PATH = os.getcwd()
CONTRACTS_PATH = os.path.join(ROOT_PATH, 'contracts')

for format in FORMATS.keys():
    format_path = os.path.join(ROOT_PATH, format)
    shutil.rmtree(format_path)
    os.mkdir(format_path)

for root, dirs, files in os.walk(CONTRACTS_PATH):
    # store the path relative to the contracts folder
    relative_path = os.path.relpath(root, CONTRACTS_PATH)
    for file in files:
        # read each .vy file
        with open(os.path.join(root, file), 'r') as read_file:
            source = read_file.read()
            outputs = compiler.compile_code(source, FORMATS)
            # for each format...
            for format, format_type in FORMATS.items():
                # make sure the format + relative path exists
                format_path = os.path.join(ROOT_PATH, format, relative_path)
                if not os.path.exists(format_path):
                    os.mkdir(format_path)
                # write the appropriate output
                file_with_extension = os.path.splitext(file)[0] + os.extsep + format_type
                with open(os.path.join(format_path, file_with_extension), 'w+') as write_file:
                    if format_type == 'json':
                        write_file.write(json.dumps(outputs[format]))
                    else:
                        write_file.write(outputs[format])
