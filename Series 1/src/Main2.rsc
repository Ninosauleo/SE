module Main2
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
import software::product::properties::Duplication2;
import software::product::properties::UnitInterfacing;


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
        "Volume"      : getVolumeScore(project),
        "Complexity"  : getUnitComplexityScore(project),
        "Duplication" : getDuplicationScore(project),
        "UnitSize"        : getUnitSizeScore(project),
        /** "UnitTesting" : XXX **/
        "UnitInterfacing"  : getUnitInterfacingScore(project)
    );
}


public map[str, num] productPropertiesToQualityCharacteristics(map[str, num] pp) {
    return (
        // ISO 9216 Analisability: Volume + Duplication + UnitSize + UnitTesting / 4
        // ISO 9126 Analisability: Volume + Duplication + UnitSize / 3
        // replace volume with duplication
        "Analisability" : round((pp["Volume"] + pp["Duplication"] + pp["UnitSize"]) / 3), 
        
        // ISO 9126 Changeability: Complexity + Duplication / 2
        "Changeability" : round((pp["Complexity"] + pp["Duplication"]) / 2),
        
        // ISO 9126 Stability: pp[UnitTesting]
        
        // ISO 9126 Testability: Complexity + UnitSize + UnitTesting / 3
        // ISO 9126 Testability: Complexity + UnitSize / 2
        // ISO 25010 Testability: Volume + Complexity + COMPONENT INDEPENDENCE
        "Testability" : round((pp["Complexity"] + pp["UnitSize"]) / 2),
        
        // iso 25010 if unit interfacing
        // iso 25010 Reusability: UnitSize + UnitInterfacing / 2
        "Reusability" : round((pp["UnitSize"] + pp["UnitInterfacing"]) / 2)
    );
}


public int overallScoreMaintainability(map[str, num] QC) {
    // add stability if time allows
    return round((QC["Analisability"] + QC["Changeability"] + QC["Testability"] + QC["Reusability"]) / 4);
}


void printVolume(loc project, map[str, num] pp) {
    print("Volume (LOC): ");
    num pLOC = countProjectLOCs(project);
    num volumeScore = pp["Volume"];
    str vScore = numToRating(volumeScore);
    str manYears = getMY(volumeScore);
    print("Rank:");
    print(" " + vScore + " " + manYears + " ");
    print(pLOC);
    println();
}


void printUnitSize(loc project, map[str, num] pp) {
    print("Unit Size: ");
    num unitSizeScore = pp["UnitSize"];
    str unitScore = numToRating(unitSizeScore);
    list[real] unitSizes = getUnitSize(project);
    print("Rank: " + unitScore + " ");
    printPercentages(unitSizes);
    println();
}

void printUnitInterfacing(loc project, map[str, num] pp) {
    print("Unit Interfacing: ");
    num unitInterSizeScore = pp["UnitInterfacing"];
    str unitInterfacingScore = numToRating(unitInterSizeScore);
    list[real] unitInterfaces = getUnitInterfacing(project);
    print("Rank: " + unitInterfacingScore + " ");
    printPercentages(unitInterfaces);
    println();
}


void printUnitComplexity(loc project, map[str, num] pp) {
    print("Unit Complexity: ");
    num ccScore = pp["Complexity"];
    str complexityScore = numToRating(ccScore);
    list[real] complexities = getCyclomaticComplexity(project);
    print("Rank: " + complexityScore + " ");
    printPercentages(complexities);
    println();
}


void printDuplicates(loc project, map[str, num] pp) {
    print("Duplication: ");
    num duplicationScore = pp["Duplication"];
    str duplicateScore = numToRating(duplicationScore);
    print("Rank: " + duplicateScore + " ");
    println();
}


private void printQualityCharacteristics (map[str, num] QC) {
    for(x <- QC) { 
        println("<x>: \t<numToRating(QC[x])>");
    }
}

private void printPercentages (list[real] percentages) {
    print("Risk: LOW ");
    print(percentages[0]);
    print(" MODERATE ");
    print(percentages[1]);
    print(" HIGH ");
    print(percentages[2]);
    print(" VERY HIGH ");
    print(percentages[3]);
}


void printMaintainability(loc project) {
    println();
    println("======================================");
    println(" Measurements / Metrics:");
    println("======================================");
    map[str, num] pp = getProductProperties(project);
    printDuplicates(project, pp);
    printVolume(project, pp);
    printUnitSize(project, pp);
    printUnitComplexity(project, pp);
    printUnitInterfacing(project, pp);
    println();
    println("======================================");
    println(" RESULTS:");
    println("======================================");
    map[str, num] qc = productPropertiesToQualityCharacteristics(pp);
    printQualityCharacteristics(qc);
    print("Maintainability (overall): ");
    print(numToRating(overallScoreMaintainability(qc)));
    println();
}
