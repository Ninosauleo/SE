module software::product::properties::CyclomaticComplexity

import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import software::product::properties::Helpers;

/**
  * Calculates cyclomatic complexity for a method
  */
int getCyclomaticComplexity(Declaration ast) {
	int complexity = 1;
	visit(ast) {
		case \if(_,_): complexity += 1;
		case \if(_,_,_): complexity += 1;
		case \case(_): complexity += 1;
		case \while(_,_): complexity += 1;
		case \infix(_, operator, _): complexity += (operator == "&&" || operator == "||")? 1 : 0;
		case \foreach(_,_,_): complexity += 1;
		case \for(_,_,_): complexity += 1;
		case \for(_,_,_,_): complexity += 1;
		case \catch(_,_): complexity += 1;
		case \conditional(_,_,_): complexity += 1;
		case \do(_,_): complexity += 1;
	}
	return complexity;
}

/**
  * Returns rating (1-5) for unit complexity of project.
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
  * Calculates per-category cyclomatic complexity for a project.
  */
list[real] getProjectCyclomaticComplexity(list[Declaration] asts) {
	list[int] cyclomaticComplexities = [0,0,0,0];
	visit(asts) {
		case Declaration d: {
			if (d.typ is \method || d.typ is \constructor) {
				x = getCyclomaticComplexity(d);
				// add value to specific bucket, based on method cyclom. complexity
				if (x <= 10) {
					cyclomaticComplexities[0] += 1;
				}
				else if (x <= 20) {
					cyclomaticComplexities[1] += 1;
				}
				else if (x <= 50) {
					cyclomaticComplexities[2] += 1;
				}
				else if (x > 50) {
					cyclomaticComplexities[3] += 1;
				}
			}
			
		}	
	}
	
	// calculate and return percentages
	return getPercentages(cyclomaticComplexities);
}