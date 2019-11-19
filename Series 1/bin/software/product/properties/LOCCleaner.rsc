module software::product::properties::LOCCleaner

import List;
import String;
import IO;

import util::Resources;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


public num counter = 0;

public num linesOfFileSize(loc file) {
	num count = 0; 
	//counter += 1;
	//println("<counter> :: reading file: <file>");
	for (line <- split("\n", stripMultiLineComments(readFile(file)))) {
		// skip empty lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		count += 1;
	}
	return count;

}

public list[str] linesOfFile(loc file) {
	return 
		for (line <- split("\n", stripMultiLineComments(readFile(file)))) {
			// skip empty lines
			if (/^[ \t]*$/ := line) {
				continue;
			}
			// skip lines starting with //
			if (/^[ \t]*\/\// := line) {
				continue;
			}
			append line;
		};
}

public list[str] linesOfFileWithComments(loc file) {
	return 
		for (line <- split("\n", readFile(file))) {
			// skip empty lines
		
			append line;
		};
}

private str stripMultiLineComments(str fileString) {
	// match /* to */, but /* must not be between strings, like String = " /* ";
	for (/<commentML:(?=(?:[^"\\]*(?:\\.|"(?:[^"\\]*\\.)*[^"\\]*"))*[^"]*$)\/\*(?s).*?\*\/>/ := fileString) {
		//print(" .");
		if (/\n/ := commentML) {
			// if the comment contains new lines, replace it with a new line
			fileString = replaceFirst(fileString, commentML, "\n");
		} else {
			fileString = replaceFirst(fileString, commentML, "");
		}
	}
	//println(" ");
	return fileString;
}
