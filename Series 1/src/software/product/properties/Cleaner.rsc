module software::product::properties::Cleaner

import List;
import String;
import IO;

import util::Resources;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


public num computeLocForFile(loc src) {
	linesOfCodeFile = removeOverhead(src);
	return size(split("\n",linesOfCodeFile));
}


public num linesOfComments = 0;

public str removeOverhead(loc file) {
	linesOfComments = 0;
	str content = standardFormat(readFile(file));
	
	return removeLeadingLine(
		removeNewLines(
		removeTabs(
		removeComments(
		content))));
}

private str standardFormat(str content) {
	content = replaceAll(content,"\r\n","\n");
	for (/<newLine:[ ]{2,}>/ := content){
		content = replaceFirst(content,newLine,"");
	}
	
	return content;
}

private str removeTabs(str content){
	return replaceAll(content,"\t","");
}

private str removeNewLines(str content){
	for (/<newLine:\n{2,}>/ := content){
		content = replaceFirst(content,newLine,"\n");
	}
	
	return content;
}

private str removeLeadingLine(str content) {
	if (/<leadingLine:^[^a-zA-Z]+>/ := content)
    	content = replaceFirst(content,leadingLine,"");
  
  return content;
}

private str removeComments(str content) {
	return removeMultiLineComments(removeSingleLineComments(removeJavaDoc(content)));
}

private str removeSingleLineComments(str content) {
	for (/<comment:\/\/[\s\S].*>/ := content) {
		content = replaceFirst(content,comment,"");
		linesOfComments += 1;
	}
	
	return content;
}

private str removeMultiLineComments(str fileString) {
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


private str removeJavaDoc(str content) {
	for (/<jdoc:\/\*[\s\S]*?\*\/>/ := content) {
		content = replaceFirst(content,jdoc,"\n");
		linesOfComments = size(split("\n",jdoc));
	 }
	
	return content;
}