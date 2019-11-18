module software::product::properties::Duplication

import IO;
import String;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import software::product::properties::Helpers;

/* 
 * finds duplicate lines of code in a project - project should be a string
 * containing all code.
 */
int getDuplicatesFromProjectString(str projectString) {

	// convert large string into per-line list of strings
	list[str] stringList = split("\n", projectString);
	stringList = stripStringList(stringList);
	println(stringList);
	
	
	int duplicates = 0;
	int maxIndex = size(stringList) - 1;
	int i = 0;
	while (i < maxIndex) {
		int j = i + ((i % 6) + 1);
		//int j = i + 7;
		//iSlice = slice(stringList,i,6);
		while (j < maxIndex) {
			//jSlice = slice(stringList,j,6);
			//if (iSlice == jSlice) {
			
			// If duplicate line found, calculate size
			if (stringList[i] == stringList[j]) {
				//int duplicateSize = getDuplicateSize(stringList, i, j);
				
				
				bool duplicateLine = true;
				int duplicateSize = 0;
				
				int initial_j = j;
				int initial_i = i;
				
				// go to beginning of duplicated block
				while (i >= 0 && j >= 0 && j > initial_i && stringList[i] == stringList[j]) {
					//println("decreasing: " + stringList[i] + " i: <i> j: <j>");
					j -= 1;
					i -= 1;
				}
				i += 1;
				j += 1;
				duplicateLine = true;
				
				// calculate size of duplicate block
				while (duplicateLine) {
					duplicateSize += 1;
					i += 1;
					j += 1;
					if (j <= maxIndex && i <= maxIndex && i < initial_j) {
						duplicateLine = stringList[i] == stringList[j];
					}
					else {
						duplicateLine = false;
					}
				}
				
				//println("duplicate size: <duplicateSize> string: <stringList[i - 1]>");
				
				// if size of duplicate block is 6 lines or more, add them to duplicate line counter
				if (duplicateSize >= 6) {
					println("duplicate: " + stringList[i - 1] + " i: <i> j: <j>");
					println(duplicateSize);
					duplicates += duplicateSize;
				}
				//i += duplicateSize;
				//j += duplicateSize;
			}
			
			// Can this be increased to 6?
			j += 6;
		}
		
		i += 1;
	}
	
	return duplicates;
}

/*
 * strips lines of code (as list of strings) from whitespace,
 * and removes empty lines of code from list.
 */
list[str] stripStringList(list[str] stringList) {
	list[str] outputList = [];
	for (line <- stringList) {
		line = replaceAll(line, " ", "");
		line = replaceAll(line, "\t", "");
		line = replaceAll(line, "\n", "");
		line = replaceAll(line, "\r", "");
		
		// exclude { and }?
		//if ((line != "") && (line != "{") && (line != "}")) {
		if (line != "") {
			outputList += line;
		}
	}
	return outputList;
}


/* 
 * Gets size of a duplicate segment. Parameters are lines
 * of code as a list, and indices of strings to compare.
 */
int getDuplicateSize(list[str] stringList, int i, int j) {
	// are current lines duplicates?
	bool duplicateLine = stringList[i] == stringList[j];
	
	// calculate size of duplicate block.
	int size = 0;
	while (duplicateLine) {
		size += 1;
		i += 1;
		j += 1;
		duplicateLine = stringList[i] == stringList[j];
	}
	
	return size;
}

int getDuplicatesFromLoc(loc projectLocation) {
	return getDuplicatesFromProjectString(getFilesAsString(projectLocation));
}


/**
  * Returns rating (1-5) for duplication in a project.
  * Returns 0 if error occured.
  */
int getDuplicationScore(loc project) {
	int locs = getLOCs(project);
	int duplicatedLocs = getDuplicates(project);
	real duplicationPercentage = duplicatedLocs / (locs * 100.0);
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