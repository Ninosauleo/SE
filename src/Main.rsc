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


