module Size

import String;
import IO;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import Helpers;

/**
  * Returns all lines of a given file.
  */
int countFileLines(loc file) {
    return size(readFileLines(file));
}

/**
  * Counts LOCs (lines - comment lines - blank lines) for a given file.
  */
int countFileLOCs(loc file) {
    int totalLines = countFileLines(file);
    int commentLines = countCommentLines(file);
    int blankLines = countBlankLines(file);
    int locs = totalLines - (commentLines + blankLines);
    return locs;
}



/**
  * Counts comment lines in a given file.
  */
int countCommentLines(loc file) {
    int n = 0;
    for(s <- readFileLines(file)) {
        if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := s) { 
            n +=1;
        }
    }
    return n;
}

/**
  * Counts blank lines in a given file.
  */
int countBlankLines(loc file) {
    int n = 0;
    for(s <- readFileLines(file)) {
        if(/^[ \t\r\n]*$/ := s) { 
            n +=1;
        }
    }
    return n;
}

/**
  * Counts LOCs for a given project location.
  */
int countProjectLOCs(loc project) {
	list[loc] files = getProjectFiles(getProjectResource(project));
	int count = 0;
	for (file <- files) {
		count += countFileLOCs(file);
	}
	return count;
}

/**
  * Gets lines of code of project based on ASTs.
  */
int getLinesOfCode(list[Declaration] asts){
    int lloc = 0;
    visit(asts){
        case \compilationUnit(i,_): lloc += size(i);
        case \compilationUnit(p,i,_): lloc += size(i) + 1;
        case \enum(_,_,c,_): lloc += size(c) + 1;
        case \class(_,_,_,_): lloc += 1;
        case \class(_): lloc += 1;
        case \interface(_,_,_,_): lloc += 1;
        case \field(_,_): lloc += 1;
        case \method(_,_,_,_,_): lloc += 1;
        case Statement x: {
          if(!(\block(_) := x)) lloc += 1;
        }
    }
    return lloc;
}

/**
  * Calculates per-category percentages of unit sizes for a project
  */
list[real] getProjectUnitSize(list[Declaration] asts) {
	list[int] unitSizes = [0,0,0,0];
	visit(asts) {
		case Declaration d: {
			if (d.typ is \method) {
				x = countFileLOCs(d.src);
				// add unit to specific bucket
				if (x <= 15) {
					unitSizes[0] += 1;
				}
				else if (x <= 30) {
					unitSizes[1] += 1;
				}
				else if (x <= 60) {
					unitSizes[2] += 1;
				}
				else {
					unitSizes[3] += 1;
				}
			}
		}
	}
	
	// calculate and return percentages
	return getPercentages(unitSizes);
}