
import csv
import time
import sys
import os

source_data = "OnlineRetail.csv"
dir_path = os.path.dirname(os.path.realpath(__file__))
os.chdir(dir_path)


def get_line_count():
    with open(source_data, encoding='latin-1') as f:
        for i, l in enumerate(f):
            pass
    return i

def make_log(start_line, num_lines):
    destData = time.strftime("/var/log/amazonlog/%Y%m%d-%H%M%S.log")
    #destData = time.strftime("%Y%m%d-%H%M%S.log")
    with open(source_data, 'r') as csvfile:
        with open(destData, 'w') as dstfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(dstfile)
            next(reader) #skip header
            input_row = 0
            lines_written = 0
            for row in reader:
                input_row += 1
                if (input_row > start_line):
                    writer.writerow(row)
                    lines_written += 1
                    if (lines_written >= num_lines):
                        break
            return lines_written
        
def main():
    num_lines = 100
    start_line = 0            
    if (len(sys.argv) > 1):
        num_lines = int(sys.argv[1])

    print("Writing " + str(num_lines) + " lines starting at line " + str(start_line) + "\n")

    totallines_written = 0
    linesInFile = get_line_count()

    while (True):
        lines_written = make_log(start_line, num_lines)
        totallines_written += lines_written
        start_line += lines_written
        if (start_line >= linesInFile):
            break
        print("Wrote " + str(totallines_written) + " lines.\n")
        time.sleep(10)
    
if __name__ == "__main__":
    main()

