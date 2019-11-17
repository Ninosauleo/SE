module CyclomaticComplexity

import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import Helpers;

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
  * Calculates per-category cyclomatic complexity for a project.
  */
list[real] getProjectCyclomaticComplexity(list[Declaration] asts) {
	list[int] cyclomaticComplexities = [0,0,0,0];
	visit(asts) {
		case Declaration d: {
			if (d.typ is \method) {
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