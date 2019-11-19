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
import software::product::properties::Duplication;
import software::product::properties::Cleaner;



list[real] getCyclomaticComplexity(loc project) {
    return getProjectCyclomaticComplexity(getASTs(project));
}


list[real] getUnitSize(loc project) {
    return getProjectUnitSize(getASTs(project));
}


int getDuplicates(loc project) {
    return getDuplicatesFromLoc(project);
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
  * Returns project as a Resource.
  */
Resource getProjectResource(loc project) {
    return getProject(project);
}


list[str] stripComments(str inputString) {
    bool commentBlock = false;
    bool addLine = true;
    list[str] stringList = split("\n", inputString);
    list[str] outputList = [];
    int prevC = 0;
    int c;
    for (line <- stringList) {
        addLine = true;
        for (c <- chars(line)) {
        
            // detect whether in comment block
            if (prevC == 47 && c == 42) {
                commentBlock = true;
            }
            if (prevC == 42 && c == 47) {
                commentBlock = false;
                addLine = false;
            }
            if (prevC == 47 && c == 47) {
                addLine = false;
            }
            
            prevC = c;
        }
        if (!commentBlock && addLine) {
            outputList += line;
        }
    }
    
    //for (line <- outputList) {
    //  println(line);
    //}
    
    return outputList;
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


int countCommentLines2(loc file) {
    
    bool commentBlock = false;
    bool addLine = true;
    list[str] stringList = split("\n", inputString);
    list[str] outputList = [];
    int prevC = 0;
    int c;
    for (line <- stringList) {
        addLine = true;
        for (c <- chars(line)) {
        
            // detect whether in comment block
            if (prevC == 47 && c == 42) {
                commentBlock = true;
            }
            if (prevC == 42 && c == 47) {
                commentBlock = false;
                addLine = false;
            }
            if (prevC == 47 && c == 47) {
                addLine = false;
            }
            
            prevC = c;
        }
        if (!commentBlock && addLine) {
            outputList += line;
        }
    }
    
    //for (line <- outputList) {
    //  println(line);
    //}
    
    return outputList;
}

/*
 * For Volume
 */

public num countLOCsOfFile(loc file) {
	num count = 0; 
	for (line <- split("\n", filterMultiLineComments(readFile(file)))) {
		
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		
		// skip blank lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		count += 1;
	}
	return count;

}

private str filterMultiLineComments(str fileString) {
	// match /* to */, but /* must not be between strings, like String = " /* ";
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
       count += countFileLines(m[0]);
       // correct below
       //count += countLOCsOfFile((m[0]));
    }
    return count;
}
