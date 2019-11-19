module First_Assignment

import IO;
import Set;
import List;
import Map;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
list[Declaration] getASTs(loc projectLocation){
    M3 model = createM3FromEclipseProject(projectLocation);
    list[Declaration] asts = [];
    for (m <- model.containment, m[0].scheme == "java+compilationUnit") {
        asts += createAstFromFile(m[0], true);
    }
    return asts;
}
int getNumberOfInterfaces(list[Declaration] asts) {
    int interfaces = 0;
    visit(asts) {
        case \interface(_, _, _, _): interfaces += 1;
    }
    return interfaces;
}


int getNumberOfFors(list[Declaration] asts){
    int fors = 0;
    visit(asts) {
        case \for(_, _, _, _): fors += 1;
        case \foreach(_, _, _): fors += 1;
        case \for(_, _, _): fors += 1;
    }
    return fors;
}

tuple[int, list[str]] mostOccuringVariable(list[Declaration] asts){
    map[str, int] vars = ();
    visit(asts) {
        case \variable(name, _): {
            if (name in vars) {
                vars[name] += 1;
            }
            else {
                vars = vars + (name: 1);
            }
        }
    }
    varsInverted = invert(vars);
    int m = max(domain(varsInverted));
    print(varsInverted[m]);
    return <m, toList(varsInverted[m])>;
}

tuple[int, list[str]] mostOccuringLiteral(list[Declaration] asts){
    map[str, int] vars = ();
    visit(asts) {
        case \number(numberValue): {
            if (numberValue in vars) {
                vars[numberValue] += 1;
            }
            else {
                vars = vars + (numberValue: 1);
            }
        }
    }
    varsInverted = invert(vars);
    int m = max(domain(varsInverted));
    print(varsInverted[m]);
    return <m, toList(varsInverted[m])>;
}

list[loc] findNullReturned(list[Declaration] asts){ 
    list[loc] locs = [];
    visit(asts) {
        case \return(expr): {
            if (expr is \null) {
                locs = locs + expr.src;
            }
        }
    }
    return locs;
}

test bool testNumberOfForLoops(){
	return getNumberOfFors(getASTs(|project://smallsql0.21_src|)) == 262;
}


