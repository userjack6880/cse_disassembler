// John Bradley 2025

#include <iostream>
#include <fstream>
#include <numeric>
#include <vector>
#include <map>

using namespace std;

map<int, string> comp_table = {
  {0b0101010, "0"   },
  {0b0111111, "1"   },
  {0b0111010, "-1"  },
  {0b0001100, "D"   },
  {0b0110000, "A"   },
  {0b1110000, "M"   },
  {0b0001101, "!D"  },
  {0b0110001, "!A"  },
  {0b1110001, "!M"  },
  {0b0001111, "-D"  },
  {0b0110011, "-A"  },
  {0b1110011, "-M"  },
  {0b0011111, "D+1" },
  {0b0110111, "A+1" },
  {0b1110111, "M+1" },
  {0b0001110, "D-1" },
  {0b0110010, "A-1" },
  {0b1110010, "M-1" },
  {0b0000010, "D+A" },
  {0b1000010, "D+M" },
  {0b0010011, "D-A" },
  {0b1010011, "D-M" },
  {0b0000111, "A-D" },
  {0b1000111, "M-D" },
  {0b0000000, "D&A" },
  {0b1000000, "D&M" },
  {0b0010101, "D|A" },
  {0b1010101, "D|M" },
  // invalid comps
  {0b1101010, ""    },
  {0b1111111, ""    },
  {0b1111010, ""    },
  {0b1001100, ""    },
  {0b1001101, ""    },
  {0b1001111, ""    },
  {0b1011111, ""    }
};

map<int, string> jump_table = {
  {0b000, ""    },
  {0b001, "JGT" },
  {0b010, "JEQ" },
  {0b011, "JGE" },
  {0b100, "JLT" },
  {0b101, "JNE" },
  {0b110, "JLE" },
  {0b111, "JMP" }
};

vector<int> open_file(const string& in_file) {
  fstream fh(in_file, ios::in);

  if (!fh.is_open()) {
    cerr << "Can't open " << in_file << "\n";
    exit(1);
  }

  vector<int> lines;
  string line;

  while (getline(fh, line)) {
    int val = stoi(line, nullptr, 2);   // interpret strings as base-2 int
    lines.push_back(val);
  }

  fh.close();

  return lines;
}

void write_file(const string& out_file, const vector<string>& lines) {
  fstream fh(out_file, ios::out);

  if (!fh.is_open()) {
    cerr << "Can't open " << out_file << "\n";
    exit(1);
  }

  for (const auto& line: lines) {
    fh << line << "\n";
  }

  fh.close();
}

bool get_bit(int value, int bit_index) {
  return (value & (1 << bit_index)) != 0;
}

int main(int argc, char *argv[])
{
  if (argc < 2) {
    cerr << "At least one file expected\n";
    exit(1);
  }

  for (int i = 1; i < argc; i++) {
    string in_file = argv[i];

    // die "must be .hack file!\n" unless $in_file =~ /\.hack$/;
    size_t fn_pos = in_file.find(".hack");
    if (fn_pos == string::npos || fn_pos != in_file.size() - 5) {
      cerr << "must be a .hack file!\n";
      exit(1);
    }

    string out_file = in_file;
    out_file.replace(fn_pos, 5, ".asm");

    // open the file and populate lines
    vector<int> binary = open_file(in_file);

    // decode the binary
    vector<string> asm_array;

    for (const auto& op: binary) {
      // determine if c or a op
      if (get_bit(op,15)) {
        // c op
        // determine comp
        int comp_val = (op >> 6) & 0b1111111; // bit shift and isolate 7 bits
        string comp = comp_table[comp_val];

        // error check
        if (comp.empty()) {
          cerr << "invalid comp: " << comp_val << "\n";
          exit(1);
        }

        // determine dest
        string dest = "";
        if (get_bit(op,5)) dest.append("A");
        if (get_bit(op,4)) dest.append("D");
        if (get_bit(op,3)) dest.append("M");

        // determine jump
        string jump = jump_table[op & 0b111]; // isolate the lowest 3 bits

        // now build the operation
        string asm_string = "";

        // dest
        if (!dest.empty()) asm_string.append(dest + "=");

        // comp
        asm_string.append(comp);

        // jump
        if (!jump.empty()) asm_string.append(";" + jump);

        asm_array.push_back(asm_string);
      }
      else {
        // a op
        string a_op = to_string(op);
        asm_array.push_back("@" + a_op); // should be safe, as bit 15 isn't used
      }
    }

    // write to file
    write_file(out_file,asm_array);
  }
}
