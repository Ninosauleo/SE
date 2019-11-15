module Helpers

import List;

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