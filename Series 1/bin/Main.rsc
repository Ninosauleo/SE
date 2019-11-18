module Main

import IO;
import Set;
import List;
import Map;
import String;
import util::Math;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import util::Resources;

import software::product::properties::CyclomaticComplexity;
import software::product::properties::Helpers;
import software::product::properties::UnitSize;
import software::product::properties::Volume;
import software::product::properties::Duplication;


/**
  * Rating number to String
  */
str numToRating(num rating) {
	str result = "";
	if(rating == 1) {
		result = "--";
	} else if(rating == 2) {
		result = "-";
	} else if(rating == 3) {
		result = "o";
	} else if(rating == 4) {
		result = "+";
	} else if(rating == 5) {
		result = "++";
	}
	
	return result;
}


public map[str, num] getProductProperties(loc project) {
	return (
		"Volume" 		: getVolumeScore(project),
		"Complexity" 	: getUnitComplexityScore(project),
		//"Duplication"	: getDuplicationScore(project),
		"UnitSize"		: getUnitSizeScore(project)
		/** "UnitTesting"	: XXX **/
		// "UnitInterfacing" 	: getUnitComplexityScore(project)
	);
}


public map[str, num] productPropertiesToQualityCharacteristics(map[str, num] pp) {
	return (
		// ISO 9216 Analisability: Volume + Duplication + UnitSize + UnitTesting / 4
		// ISO 9126 Analisability: Volume + Duplication + UnitSize / 3
		// here one VOLUME SHOULD BE REPLACED WITH DUPLICATION
		"Analisability" : round((pp["Volume"] + pp["Volume"] + pp["UnitSize"]) / 3), 
		
		// ISO 9126 Changeability: Complexity + Duplication / 2
		// here VOLUME SHOULD BE REPLACED WITH DUPLICATION
		"Changeability" : round((pp["Complexity"] + pp["Volume"]) / 2),
		
		// ISO 9126 Stability: pp[UnitTesting]
		
		// ISO 9126 Testability: Complexity + UnitSize + UnitTesting / 3
		// ISO 9126 Testability: Complexity + UnitSize / 2
		// ISO 25010 Testability: Volume + Complexity + COMPONENT INDEPENDENCE
	    "Testability"	: round((pp["Complexity"] + pp["UnitSize"]) / 2)
	    
	    // iso 25010 if unit interfacing
	    // iso 25010 Reusability: UnitSize + UnitInterfacing / 2
	);
}

public int overallScoreMaintainability(map[str, num] QC) {
	// add stability if time allows
	return round((QC["Analisability"] + QC["Changeability"] + QC["Testability"]) / 3);
}


void printVolume(loc project, map[str, num] pp) {
	print("Volume (LOC): ");
	int pLOC = getLOCs(project);
	num volumeScore = pp["Volume"];
	str vScore = numToRating(volumeScore);
	str manYears = getMY(volumeScore);
	print("Rank: ");
	print(" " + vScore + " " + manYears + " ");
	print(pLOC);
	println();
}

void printUnitSize(loc project, map[str, num] pp) {
	print("Unit Size: ");
	num unitSizeScore = pp["UnitSize"];
	str unitScore = numToRating(unitSizeScore);
	print("Rank: " + unitScore + " ");
	println();
}

void printUnitComplexity(loc project, map[str, num] pp) {
	print("Unit Complexity: ");
	num ccScore = pp["Complexity"];
	str complexityScore = numToRating(ccScore);
	print("Rank: " + complexityScore + " ");
	println();

}

void printDuplicates(loc project, map[str, num] pp) {
	print("Duplicates: ");
	println();

}

private void printQualityCharacteristics (map[str, num] mapQC) {
	for(x <- mapQC) { 
		println("<x>: \t<numToRating(mapQC[x])>");
	}
}


void printMaintainability(loc project) {
	println();
	println("======================================");
	println(" Measurements / Metrics:");
	println("======================================");
	map[str, num] pp = getProductProperties(project);
	
	printVolume(project, pp);
	printUnitSize(project, pp);
	printUnitComplexity(project, pp);
	//printDuplicates(project);
	println();
	// NINO REMOVE OTHER PROJECT WHEN YOURE DONE
	// NINO REMOVE OTHER PROJECT WHEN YOURE DONE
	// NINO REMOVE OTHER PROJECT WHEN YOURE DONE
	// NINO REMOVE OTHER PROJECT WHEN YOURE DONE
	println("======================================");
	println(" RESULTS:");
	println("======================================");
	map[str, num] qc = productPropertiesToQualityCharacteristics(pp);
	printQualityCharacteristics(qc);
	print("Maintainability (overall): ");
	print(overallScoreMaintainability(qc));
	println();
}



