<DOCTYPE html>
<head>
	<title>DoccoCF</title>
	<link rel="stylesheet" media="all" href="docco.css">
</head>
<body>
	<div id="container">
		<div id="background"></div>

		<table cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<th class="docs">
						<h1>DoccoCF</h1>
					</th>
					<th class="code"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class='docs'>
<cfscript>

_ = new github.UnderscoreCF.Underscore();

myfile = FileOpen(expandPath("../UnderscoreCF/Underscore.cfc"), "read");
lineNum = 1;
isInCommentBlock = false;
isInCodeBlock = true;
codeBlock = "";
commentBlock = "";
while (!FileisEOF(myfile))
{
	line = FileReadLine(myfile); // read line

	// TODOs
	// use regex to find and pull out comments

	isSingleLineComment = left(trim(line), 2) == "//";
	isOpeningComment = left(trim(line), 2) == "/*";
	isClosingCommentRE =  reFind("\*\/", line, 1, true);
	if (isClosingCommentRE.len[1] > 0) {
		isClosingComment = true;
	}
	else {
		isClosingComment = false;
	}

	if (isOpeningComment && !isInCommentBlock) {
		isInCommentBlock = true;
		continue;
	}

	if (isClosingComment && isInCommentBlock) {
		isInCommentBlock = false;
		writeOutput(commentBlock);
		commentBlock = "";
		continue;
	}

	if (isInCommentBlock) {
		line = trim(line);
		lineLen = max(len(line)-2, 1);
		line = right(line, lineLen);
		line = trim(line);
		if (line == '*' || line == '') {
			continue;
		}
		if (left(line, 1) == '@') {
			line = right(line, len(line)-1);
			sub = listFirst(line, ' ');
			line = replace(line, sub, '<b>#sub#:</b>');
		}
		commentBlock = commentBlock & "<br />" & line;
	}

	if (!isInCommentBlock && !isSingleLineComment) {
		isInCodeBlock = true;
	}
	else if (isInCodeBlock) {
		// already in code block, now comments have started
		writeOutput("</td><td class='code'><pre>" & codeBlock & "</pre></td></tr><tr><td class='docs'>");
		codeBlock = "";
		isInCodeBlock = false;
	}

	if (isSingleLineComment) {
		line = trim(line);
		line = right(line, len(line)-2);
		writeOutput(line);
	}

	if (isInCodeBlock) {
		codeBlock = codeBlock & "<br />" & line;
	}

	// TODO:
	// parse markdown in comments

	// use syntax highlighting for code
}
FileClose(myfile);



</cfscript>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>