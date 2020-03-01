#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2020 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

scenarios(simulator => 1);

if (!$Self->have_sc) {
    skip("No SystemC installed");
}
else {
    top_filename("t_trace_two_a.v");

    compile(
        make_main => 0,
        verilator_make_gmake => 0,
        top_filename => 't_trace_two_b.v',
        VM_PREFIX => 'Vt_trace_two_b',
        verilator_flags2 => ['-sc -trace'],
        );

    compile(
        make_main => 0,
        top_filename => 't_trace_two_a.v',
        verilator_flags2 => ['-sc', '-exe', '-trace',
                             "$Self->{t_dir}/t_trace_two_hdr_sc.cpp"],
        );

    execute(
        check_finished => 1,
        );

    if ($Self->{vlt_all}) {
        file_grep("$Self->{obj_dir}/simx.vcd", qr/\$enddefinitions/x);
        vcd_identical("$Self->{obj_dir}/simx.vcd", $Self->{golden_filename});
    }
}

ok(1);
1;