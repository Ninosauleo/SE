module software::product::properties::Volume

import String;
import IO;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import software::product::properties::Helpers;


private loc test0 = |project://Test/src/test/Volume/EmptyClass.java|;
private loc test1 = |project://Test/src/test/Volume/NormalClass.java|;
private loc test2 = |project://Test/src/test/Volume/SingleLineCommentedClass.java|;
private loc test3 = |project://Test/src/test/Volume/MultilineCommentedClass.java|;
private loc test4 = |project://Test/src/test/Volume/Annotations.java|;


/**
  * Returns rating (1-5) for project volume. Returns 0 if error
  * occured.
  */
int getVolumeScore(loc project) {
	int locs = getLOCs(project);
	if (locs <= 66000) {
		return 5;
	}
	else if (locs <= 246000) {
		return 4;
	}
	else if (locs <= 665000) {
		return 3;
	}
	else if (locs <= 1310000) {
		return 2;
	}
	else if (locs > 1310000) {
		return 1;
	}
	else {
		return 0;
	}
}

public str getMY(int rank) {
	if (rank == 5) return "(0-8 MY)";
	if (rank == 4) return "(8-30 MY)";
	if (rank == 3) return "(30-80 MY)";
	if (rank == 2) return "(80-160 MY)";
	return "(\>160 MY)";
}

/**
  * Tests
  */
test bool testNumberOfLOCSFile0(){
	return countFileLOCs(test0) == 3;
}
test bool testNumberOfLOCSFile1(){
	return countFileLOCs(test1) == 6;
}
test bool testNumberOfLOCSFile2(){
	return countFileLOCs(test2) == 6;
}

/**
test bool testNumberOfLOCSFile3(){
	return countFileLOCs(test3) == 6;
}
test bool testNumberOfLOCSFile4(){
	return countFileLOCs(test4) == 39;
}
*/



