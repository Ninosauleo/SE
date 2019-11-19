module software::product::properties::Helpers
import List;
import String;
import IO;
import util::Resources;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import software::product::properties::CyclomaticComplexity;
import software::product::properties::UnitSize;
import software::product::properties::Volume;
import software::product::properties::Duplication2;
import software::product::properties::Cleaner;
import software::product::properties::UnitInterfacing;



list[real] getCyclomaticComplexity(loc project) {
    return getProjectCyclomaticComplexity(getASTs(project));
}

list[real] getUnitInterfacing(loc project) {
    return getUnitInterfacingSize(getASTs(project));
}

list[real] getUnitSize(loc project) {
    return getProjectUnitSize(getASTs(project));
}



/**
  * Returns list of percentages that fall in a specific bucket.
  * Argument needs to be list with 4 buckets.
  */
list[real] getPercentages(list[int] buckets) {
    list[real] percentages = [0.0, 0.0, 0.0, 0.0];
    sumBuckets = sum(buckets);
    percentages[0] = (buckets[0] * 100.0) / sumBuckets;
    percentages[1] = (buckets[1] * 100.0) / sumBuckets;
    percentages[2] = (buckets[2] * 100.0) / sumBuckets;
    percentages[3] = (buckets[3] * 100.0) / sumBuckets;
    return percentages;
}


/**
  * Gets ASTs for a given project location.
  */
list[Declaration] getASTs(loc projectLocation){
    M3 model = createM3FromEclipseProject(projectLocation);
    list[Declaration] asts = [];
    for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
        asts += createAstFromFile(m[0], true);
    }
    return asts;
}


/**
  * gets files of a project (project argument must be a Resource).
  */
list[loc] getProjectFiles(Resource project) {
    list[loc] projectLocation = [];
    for (/file(l) := project) {
        projectLocation += l;
    }
    return projectLocation;
}


/**
  * Gets projects of Eclipse workspace.
  */
set[loc] getProjects() {
    return projects();
}



/**
  * Returns full project Java source text as a string.
  */
str getFilesAsString(loc projectLocation){
    M3 model = createM3FromEclipseProject(projectLocation);
    str filesString = "";
    for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
        filesString += readFile(m[0]) + "\n";
    }
    return filesString;
}


/*
* For Duplication
*/

public list[str] linesOfFileWithoutComments(loc file) {
	return 
		for (line <- split("\n", filterMultiLineComments(readFile(file)))) {
			// skip lines starting with //
			if (/^[ \t]*\/\// := line) {
				continue;
			}
			// skip empty lines
			if (/^[ \t]*$/ := line) {
				continue;
			}
			append line;
		};
}

public list[str] linesOfFileIncludeComments(loc file) {
    return 
        for (line <- split("\n", readFile(file))) {
            // skip empty lines
            if (/^[ \t]*$/ := line) {
                continue;
            }
        
            append line;
        };
}

/*
 * For Volume
 */

public num countLOCsOfFile(loc file) {
	num countLOC = 0; 
	for (line <- split("\n", filterMultiLineComments(readFile(file)))) {
		
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		
		// skip blank lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		countLOC += 1;
	}
	return countLOC;

}


/*
* Both used in Volume and Duplication
*/

private str filterMultiLineComments(str fileString) {
	// match /* to */
	for (/<commentML:(?=(?:[^"\\]*(?:\\.|"(?:[^"\\]*\\.)*[^"\\]*"))*[^"]*$)\/\*(?s).*?\*\/>/ := fileString) {
		if (/\n/ := commentML) {
			// if the comment contains new lines, replace it with a new line
			fileString = replaceFirst(fileString, commentML, "\n");
		} else {
			fileString = replaceFirst(fileString, commentML, "");
		}
	}
	return fileString;
}

/**
  * Returns count of LOC a given file.
  */
int countFileLines(loc file) {
    return size(readFileLines(file));
}


/**
  * Counts LOCs for Java source text.
  */
num countProjectLOCs(loc project){
    M3 model = createM3FromEclipseProject(project);
    num count = 0;
    for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
       // fast but wrong
       //count += countFileLines(m[0]);
       // correct below
       count += countLOCsOfFile((m[0]));
    }
    return count;
}
