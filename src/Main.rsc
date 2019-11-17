module Main

import IO;
import Set;
import List;
import Map;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Resources;

import CyclomaticComplexity;
import Helpers;
import Size;
import Duplication;



// LOGIC

/**
  * 
  */
//int getUnitSize(list[Declaration] asts) {
//    visit(asts) {
//        case Declaration d: {
//            if (d.typ is \method) {
//                println(d);
//                totalLines = countFileLOCs(d.src);
//                println(totalLines);
//            }
//        }   
//    }
//    return 0;
//}



list[real] getCyclomaticComplexity(loc project) {
	return getProjectCyclomaticComplexity(getASTs(project));
}

list[real] getUnitSize(loc project) {
	return getProjectUnitSize(getASTs(project));
}

int getDuplicates(loc project) {
	return getDuplicatesFromLoc(project);
}

int getLOCs(loc project) {
	return countProjectLOCs(project);
}

/**
  * Returns star rating (1-5) for project volume. Returns 0 if error
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


/**
  * Returns star rating (1-5) for unit complexity of project.
  */
int getUnitComplexityScore(loc project) {
	list[real] complexities = getCyclomaticComplexity(project);
	
	if (complexities[1] <= 25.0 && complexities[2] <= 0.0 && complexities[3] <= 0.0) {
		return 5;
	}
	else if (complexities[1] <= 30.0 && complexities[2] <= 5.0 && complexities[3] <= 0.0) {
		return 4;
	}
	else if (complexities[1] <= 40.0 && complexities[2] <= 10.0 && complexities[3] <= 0.0) {
		return 3;
	}
	else if (complexities[1] <= 50.0 && complexities[2] <= 15.0 && complexities[3] <= 5.0) {
		return 2;
	}
	else {
		return 1;
	}
}


/**
  * Returns star rating (1-5) for unit size of project.
  */
int getUnitSizeScore(loc project) {
	list[real] sizes = getUnitSize(project);
	
	if (sizes[1] <= 25.0 && sizes[2] <= 0.0 && sizes[3] <= 0.0) {
		return 5;
	}
	else if (sizes[1] <= 30.0 && sizes[2] <= 5.0 && sizes[3] <= 0.0) {
		return 4;
	}
	else if (sizes[1] <= 40.0 && sizes[2] <= 10.0 && sizes[3] <= 0.0) {
		return 3;
	}
	else if (sizes[1] <= 50.0 && sizes[2] <= 15.0 && sizes[3] <= 5.0) {
		return 2;
	}
	else {
		return 1;
	}
}

/**
  * Returns star rating (1-5) for duplication in a project.
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

/**
  * Gets average score for of all 4 metrics for a project.
  */
real getOverallScore(loc project) {
	int volumeScore = getVolumeScore(project);
	int unitComplexityScore = getUnitComplexityScore(project);
	int unitSizeScore = getUnitSizeScore(project);
	int duplicationScore = getDuplicationScore(project);
	
	println(volumeScore);
	println(unitComplexityScore);
	println(unitSizeScore);
	println(duplicationScore);
	
	return (volumeScore + unitComplexityScore + unitSizeScore + duplicationScore) / 4.0;
}

