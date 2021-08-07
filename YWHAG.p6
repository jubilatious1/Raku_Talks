

say "YWHAG";
say "YWHAE";
"\n\n____".say;

#Three forms:
say "YWHAG".match( /YWHAG/, :global);
say "YWHAG".match: /YWHAG/, :global;
say "YWHAG" ~~ m:global/YWHAG/;  #smartmatch
say "YWHAG" ~~ Str; #asymmetric
say Str ~~ "YWHAG"; #asymmetric

"\n0.____Should match 2 LHS_values\n".say;

say so "YWHA"   ~~ m:g/YWHA <[GE]>  /; #CORRECT
say so "YWHAG"  ~~ m:g/YWHA <[GE]>  /; #FALSE-POS
say so "YWHAE"  ~~ m:g/YWHA <[GE]>  /; #FALSE-POS
say so "YWHAEG" ~~ m:g/YWHA <[GE]>  /; #WRONG!
"--".put;
say so "YWHA"   ~~ m:g/YWHA <[GE]> $/; #CORRECT
say so "YWHAG"  ~~ m:g/YWHA <[GE]> $/; #CORRECT
say so "YWHAE"  ~~ m:g/YWHA <[GE]> $/; #CORRECT
say so "YWHAEG" ~~ m:g/YWHA <[GE]> $/; #CORRECT

"\n\n\n\n\n".say;

my regex end1 { <[GE]> };
#alt example: <digit>
#as in <digit>*, <digit>+, <digit>**1..4;

"\n1.____Should match 2 LHS_values\n".say;

say so "YWHA"   ~~ m:g/YWHA <end1> $/; #CORRECT
say so "YWHAG"  ~~ m:g/YWHA <end1> $/; #CORRECT
say so "YWHAE"  ~~ m:g/YWHA <end1> $/; #CORRECT
say so "YWHAEG" ~~ m:g/YWHA <end1> $/; #CORRECT

"\n2.____Show match objects\n".say;

say $/ if "YWHA"   ~~ m/YWHA <end1> $/; #CORRECT
say $/ if "YWHAG"  ~~ m/YWHA <end1> $/; #CORRECT
say $/ if "YWHAE"  ~~ m/YWHA <end1> $/; #CORRECT
say $/ if "YWHAEG" ~~ m/YWHA <end1> $/; #CORRECT

"\n3.____Should match 2/3 genes\n\n".say;

my  $mixed_w_bad = <<YWHAG YWHAE WYHAEG>>;
say $mixed_w_bad.raku;
say $mixed_w_bad.elems;
say $mixed_w_bad.grep(/YWHA <end1> $/); #CORRECT

say "\n\n";

