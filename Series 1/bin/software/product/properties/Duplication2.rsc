module software::product::properties::Duplication2
import IO;
import String;
import List;
import Set;
import Map;
import Relation;
import util::Math;
import util::Benchmark;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import software::product::properties::Helpers;

private loc test0 = |project://Duplication/src/Duplication0.java|;
private loc test1 = |project://Duplication2/src/Duplication1.java|;
//private loc test0 = |project://Test/src/test/Duplication/Duplication0.java|;

/*
private loc test2 = |project://Test/src/test/Duplication/Duplication34.java|;
*/




num getPercentageOfDuplication(tuple[num totalLines, num dupeLines] result) {
	return round((result.dupeLines / result.totalLines) * 100);
}

void printlinesOfDuplication(tuple[num totalLines, num dupeLines] result) {
	print("Lines Of Duplicated Code: ");
	println(result.dupeLines);
	print("Total Lines of Code (For duplication / by method): ");
	println(result.totalLines);
}

tuple[num, num] getDuplicationLines(loc project) {
	// method matching strings is faster then matching lists;
	M3 projectAST = createM3FromEclipseProject(project);
	set[loc] allMethods = methods(projectAST);
	// set to true if filter by multi-line
	bool checkComments = false;
	print("Duplication checks comments is se to: ");
	println(checkComments);
	tuple[num totalLines, num dupeLines] result = getDuplicationUsingStringMatchingWithParams(allMethods, checkComments);
	return result;
}


public tuple[num, num] getDuplicationUsingStringMatchingWithParams(set[loc] files, bool removeMultiLine) {
	// this set will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	list[str] allLines = [];
	if (removeMultiLine) {
		allLines = ([] | it + [ trim(line) | line <- linesOfFileWithoutComments(f) ] | loc f <- files);
	} else if (!removeMultiLine) {
		allLines = ([] | it + [ trim(line) | line <- linesOfFileIncludeComments(f) ] | loc f <- files);
	} 
	
	str allLinesTogether = intercalate("\n", allLines);
	
	// block of 6 lines of code 
	for (startLine <- [0..(size(allLines)-6)]) {
		str searchString = "\n" + intercalate("\n", slice(allLines, startLine, 6));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			// mark these items as duplicate lines		
			duplicateLines += toSet([startLine..(startLine+6)]);
		}
	}

 	num lines = size(allLines);
 	num dupes = size(duplicateLines);
	
	return <lines,dupes>;
}


/**
  * Returns rating (1-5) for duplication in a project.
  * Returns 0 if error occured.
  */
int getDuplicationScore(loc project) {
    //int locs = getLOCs(project);
    //int duplicatedLocs = getDuplicates(project);
    tuple[num totalLines, num dupeLines] result = getDuplicationLines(project);
    
    num duplicationPercentage = getPercentageOfDuplication(result);
    printlinesOfDuplication(result);
    print("Percentage of Duplicated Lines: ");
    println(duplicationPercentage);
    if (duplicationPercentage <= 3.0) {
        return 5;
    }
    else if (duplicationPercentage <= 5.0) {
        return 4;
    }
    else if (duplicationPercentage <= 10.0) {
        return 3;
    }
    else if (duplicationPercentage <= 20.0) {
        return 2;
    }
    else if (duplicationPercentage <= 100.0) {
        return 1;
    }
    else {
        return 0;
    }
}


/**
  * Tests
  */
test bool testDuplicationFile0(){
	tuple[num totalLines, num dupeLines] result = getDuplicationLines(test0);
	println(result.dupeLines);
    return result.dupeLines == 14;
}

test bool testDuplicationFile1(){
	tuple[num totalLines, num dupeLines] result = getDuplicationLines(test1);
	println(result.dupeLines);
    return result.dupeLines == 16;
}
