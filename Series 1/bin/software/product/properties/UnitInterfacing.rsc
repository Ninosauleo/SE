module software::product::properties::UnitInterfacing

import IO;
import String;
import List;
import Set;
import Map;
import Relation;
import util::Math;
import util::Benchmark;


import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import software::product::properties::Helpers;



/**
  * Returns rating (1-5) for unit interfacing of project.
  */
int getUnitInterfacingScore(loc project) {
	list[real] complexities = getUnitInterfacing(project);
	
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


list[real] getUnitInterfacingSize(list[Declaration] asts) {
	list[int] unitSizes = [0,0,0,0];
    //list[real] percentages = [0.0, 0.0, 0.0, 0.0];
    
    visit(asts){
        case \method(_,_,p,_,_):{
        int numberOfParameters = size(p);
        // size(p));
        // Benchmarks taken from BuildingMaintainableSoftwareSIG page 64
        // at most two paramenters
        if (numberOfParameters <= 2) {
                    unitSizes[0] += 1;
        }
        // three or more parameters
        else if (numberOfParameters > 2 && numberOfParameters < 5) {
                    unitSizes[1] += 1;
        }
        // five or more parameters
        else if (numberOfParameters >= 5 && numberOfParameters <= 7) {
            unitSizes[2] += 1;
        }
        // more than seven paramaters
        else {
            unitSizes[3] += 1;
        	}
        }
        
        case \constructor(_,b,_,_):{
        int numberOfParameters = size(b);
        // size(p));
        // Benchmarks taken from BuildingMaintainableSoftwareSIG page 64
        // at most two paramenters
        if (numberOfParameters <= 2) {
                    unitSizes[0] += 1;
        }
        // three or more parameters
        else if (numberOfParameters > 2 && numberOfParameters < 5) {
                    unitSizes[1] += 1;
        }
        // five or more parameters
        else if (numberOfParameters >= 5 && numberOfParameters <= 7) {
            unitSizes[2] += 1;
        }
        // more than seven paramaters
        else {
            unitSizes[3] += 1;
        	}
        }
        
        
    }
    return getPercentages(unitSizes);
}