# John Bradley 2025

use strict;
use warnings;

my %comp_table = (
  0b0101010 => '0',
  0b0111111 => '1',
  0b0111010 => '-1',
  0b0001100 => 'D',
  0b0110000 => 'A',
  0b1110000 => 'M',
  0b0001101 => '!D',
  0b0110001 => '!A',
  0b1110001 => '!M',
  0b0001111 => '-D',
  0b0110011 => '-A',
  0b1110011 => '-M',
  0b0011111 => 'D+1',
  0b0110111 => 'A+1',
  0b1110111 => 'M+1',
  0b0001110 => 'D-1',
  0b0110010 => 'A-1',
  0b1110010 => 'M-1',
  0b0000010 => 'D+A',
  0b1000010 => 'D+M',
  0b0010011 => 'D-A',
  0b1010011 => 'D-M',
  0b0000111 => 'A-D',
  0b1000111 => 'M-D',
  0b0000000 => 'D&A',
  0b1000000 => 'D&M',
  0b0010101 => 'D|A',
  0b1010101 => 'D|M',
  # invalid comps
  0b1101010 => '',
  0b1111111 => '',
  0b1111010 => '',
  0b1001100 => '',
  0b1001101 => '',
  0b1001111 => '',
  0b1011111 => ''
);

my %jump_table = (
  0b000 => '',
  0b001 => 'JGT',
  0b010 => 'JEQ',
  0b011 => 'JGE',
  0b100 => 'JLT',
  0b101 => 'JNE',
  0b110 => 'JLE',
  0b111 => 'JMP'
);

sub open_file {
  my $in_file = shift;

  open my $fh, '<', $in_file or die "Can't open $in_file: $!\n";

  my @lines;

  while (my $line = <$fh>) {
    chomp $line;                # truncate newline
    my $val = oct("0b$line");   # interpret strings as base-2 int
    push @lines, $val;
  }

  close $fh;

  return @lines;
}

sub write_file {
  my ($out_file, @lines) = @_;

  open my $fh, '>', $out_file or die "Can't open $out_file: $!\n";

  print $fh join("\n", @lines);
  print $fh "\n"; # add in the last linebreak

  close $fh;
}

sub get_bit {
  my ($value, $bit_index) = @_;
  return ($value & (1 << $bit_index)) ? 1 : 0;
}

die "At least one file expected\n" if scalar @ARGV < 1;

for my $in_file (@ARGV) {
  die "must be .hack file!\n" unless $in_file =~ /\.hack$/;

  my $out_file = $in_file =~ s/.hack/.asm/r;

  # open the file and populate lines
  my @binary = open_file($in_file);

  # decode the binary
  my @asm = ();

  foreach my $op (@binary) {
    # determine if c or a op
    if (get_bit($op,15)) {
      # c op
      # determine comp
      my $comp_val = ($op >> 6) & 0b1111111;   # bit shift and isolate 7 bits
      my $comp = $comp_table{$comp_val};

      # error check
      die sprintf "invalid comp: %07b\n", $comp_val if $comp eq '';

      # determine dest
      my $dest = '';
      $dest .= "A" if get_bit($op,5);
      $dest .= "D" if get_bit($op,4);
      $dest .= "M" if get_bit($op,3);

      # determine jump
      my $jump = $jump_table{$op & 0b111};  # isolate the lowest 3 bits

      # now build the operation
      my $asm = '';

      # dest
      $asm .= "$dest=" if $dest ne '';

      # comp
      $asm .= $comp;

      # jump
      $asm .= ";$jump" if $jump ne '';

      push @asm, $asm;
    }
    else {
      # a op
      push @asm, "\@$op"; # should be safe, as bit 15 isn't used
    }
  }

  # write to file
  write_file($out_file, @asm);
}
