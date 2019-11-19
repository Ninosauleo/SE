module software::product::properties::UnitSize

import String;
import IO;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import software::product::properties::Helpers;


/**
  * Calculates per-category percentages of unit sizes for a project
  */
list[real] getProjectUnitSize(list[Declaration] asts) {
	list[int] unitSizes = [0,0,0,0];
	visit(asts) {
		case Declaration d: {
			if (d.typ is \method || d.typ is \constructor) {
				x = countFileLines(d.src);
				// add unit to specific bucket
				if (x <= 15) {
					unitSizes[0] += 1;
				}
				else if (x <= 30) {
					unitSizes[1] += 1;
				}
				else if (x <= 60) {
					unitSizes[2] += 1;
				}
				else {
					unitSizes[3] += 1;
				}
			}
		}
	}
	
	// calculate and return percentages
	return getPercentages(unitSizes);
}

/**
  * Returns rating (1-5) for unit size of project.
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