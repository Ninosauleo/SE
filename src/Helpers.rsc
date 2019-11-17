module Helpers

import List;
import String;
import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Resources;



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

//str stripComments(str inputString) {
//	bool commentBlock = false;
//	list[str] stringList = split("\n", inputString);
//	list[str] outputList = [];
//	for (line <- stringList) {
//		if (/.*\/\*.*/ := line) {
//			commentBlock = true;
//		}
//		else if (commentBlock == true && (/.*\*\/.*/ := line)){
//			commentBlock = false;
//		}
//		if (/.*\/\*.*\*\// := line) {
//			commentBlock = false;
//		}
//	
//		if (commentBlock == false) {
//			outputList += [line];
//		}
//		
//	}
//}

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
			
			prevC = c;
		}
		if (!commentBlock && addLine) {
			outputList += line;
		}
	}
	
	for (line <- outputList) {
		println(line);
	}
	
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



