// RUN: %dafny /compile:3 /spillTargetCode:2 /compileTarget:cs "%s" > "%t"
// RUN: %dafny /compile:3 /spillTargetCode:2 /compileTarget:js "%s" >> "%t"
// RUN: %dafny /compile:3 /spillTargetCode:2 /compileTarget:go "%s" >> "%t"
// RUN: %diff "%s.expect" "%t"

method LinearSearch(a: array<int>, key: int) returns (n: nat)
  ensures 0 <= n <= a.Length
  ensures n == a.Length || a[n] == key
{
  n := 0;
  while n < a.Length
    invariant n <= a.Length
  {
    if a[n] == key {
      return;
    }
    n := n + 1;
  }
}

method PrintArray(a: array) {
  var i := 0;
  while i < a.Length {
    print a[i], " ";
    i := i + 1;
  }
  print "\n";
}

method Main() {
  var a := new int[23];
  var i := 0;
  while i < 23 {
    a[i] := i;
    i := i + 1;
  }
  PrintArray(a);
  var n := LinearSearch(a, 17);
  print n, "\n";
  print a[..], "\n";
  print a[2..16], "\n";
  print a[20..], "\n";
  print a[..8], "\n";

  InitTests();
  
  MultipleDimensions();
}

type lowercase = ch | 'a' <= ch <= 'z' witness 'd'
  
method InitTests() {
  var aa := new lowercase[3];
  PrintArray(aa);
  var s := "hello";
  aa := new lowercase[|s|](i requires 0 <= i < |s| => s[i]);
  PrintArray(aa);
}

method MultipleDimensions() {
  var matrix := new int[2,8];
  PrintMatrix(matrix);
  matrix := new int[3, 5]((x,y) => if x==y then 1 else 0);
  PrintMatrix(matrix);

  var cube := new int[3,0,4]((_,_,_) => 16);
  print "cube dims: ", cube.Length0, " ", cube.Length1, " ", cube.Length2, "\n";
}

method PrintMatrix(m: array2<int>) {
  var i := 0;
  while i < m.Length0 {
    var j := 0;
    while j < m.Length1 {
      print m[i,j], " ";
      j := j + 1;
    }
    print "\n";
    i := i + 1;
  }
}
