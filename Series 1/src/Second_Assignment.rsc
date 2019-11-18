module Second_Assignment

import IO;
import Set;
import List;
import Map;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Resources;


set[loc] getProjects(loc project) {
    return projects();
}


Resource getProjectResource(loc project) {
    return getProject(project);
}


list[loc] getProjectFiles(Resource project) {
    list[loc] projectLocation = [];
    for (/file(l) := project) {
        projectLocation += l;
    }
    return projectLocation;
}


list[Declaration] getASTs(loc projectLocation){
    M3 model = createM3FromEclipseProject(projectLocation);
    list[Declaration] asts = [];
    for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
        asts += createAstFromFile(m[0], true);
    }
    return asts;
}

int countASTLOCs(loc file) {
    int totalLines = countFileLines(file);
    int commentLines = countCommentLines(file);
    int blankLines = countBlankLines(file);
    int locs = totalLines - (commentLines + blankLines);
    return locs;
}


int countFileLines(loc file) {
    return size(readFileLines(file));
}


int countCommentLines(loc file) {
    int n = 0;
    for(s <- readFileLines(file)) {
        if(/((\s|\/*)(\/\*|\s\*)|[^\w,\;]\s\/*\/)/ := s) { 
            n +=1;
        }
    }
    return n;
}


int countBlankLines(loc file) {
    int n = 0;
    for(s <- readFileLines(file)) {
        if(/^[ \t\r\n]*$/ := s) { 
            n +=1;
        }
    }
    return n;
}


int getUnitSize(list[Declaration] asts) {
    visit(asts) {
        case Declaration d: {
            if (d.typ is \method) {
                //println(d);
                totalLines = countASTLOCs(d.src);
                println(totalLines);
            }
        }   
    }
    return 0;
}



int getCyclomaticComplexity(Declaration ast) {
    int complexity = 1;
    visit(ast) {
        case \if(_,_): complexity += 1;
        case \if(_,_,_): complexity += 1;
        case \case(_): complexity += 1;
        case \while(_,_): complexity += 1;
        case \do(_,_): complexity += 1;
    }
    return complexity;
}


list[real] getProjectCyclomaticComplexity(list[Declaration] asts) {
    list[int] cyclomaticComplexities = [0,0,0,0];
    list[real] percentages = [0.0,0.0,0.0,0.0];
    visit(asts) {
        case Declaration d: {
            if (d.typ is \method) {
                x = getCyclomaticComplexity(d);
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
    sumComplexities = sum(cyclomaticComplexities);
    percentages[0] = (cyclomaticComplexities[0] * 100.0) / sumComplexities;
    percentages[1] = (cyclomaticComplexities[1] * 100.0) / sumComplexities;
    percentages[2] = (cyclomaticComplexities[2] * 100.0) / sumComplexities;
    percentages[3] = (cyclomaticComplexities[3] * 100.0) / sumComplexities;
    return percentages;
}


list[real] getProjectUnitSize(list[Declaration] asts) {
    list[int] unitSizes = [0,0,0,0];
    list[real] percentages = [0.0, 0.0, 0.0, 0.0];
    visit(asts) {
        case Declaration d: {
            if (d.typ is \method) {
                x = countASTLOCs(d.src);
                // Benchmarks taken from BuildingMaintainableSoftwareSIG page 25
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
    sumUnitSizes = sum(unitSizes);
    percentages[0] = (unitSizes[0] * 100.0) / sumUnitSizes;
    percentages[1] = (unitSizes[1] * 100.0) / sumUnitSizes;
    percentages[2] = (unitSizes[2] * 100.0) / sumUnitSizes;
    percentages[3] = (unitSizes[3] * 100.0) / sumUnitSizes;
    return percentages;
}


list[int] getUnitInterfacingSize(list[Declaration] asts) {
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
    }
    return unitSizes;
}
