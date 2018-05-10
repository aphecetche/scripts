#include <sstream>
#include "Riostream.h"

void generateBookletTex(int n=72, 
	const char* inputPDFfile="/Users/laurent/Desktop/Private/Agenda Décembre - Août 2015",
	const char* outputName="booklet")
{
	int a = n;
	int b = 1;
	
	std::ostringstream s;
	
	for ( int i = 0; i < n/8; ++i ) 
	{
		s << a << "," << b << "," << a-2 << "," << b+2
		<< "," << b+1 << "," << a-1 << "," << b+3 << "," << a-3;
		
		if ( i+1 < n/8 ) s << ",";
		
		a -= 4;
		b += 4;
	}
	
	std::string texFile(outputName);
	texFile += ".tex";
	
	std::ofstream out(texFile);
	
	out << "\\documentclass[a4paper]{article}" << std::endl;
	out << "\\usepackage[pdftex]{color,graphicx,epsfig}" << std::endl;
	out << "\\usepackage[final]{pdfpages}" << std::endl;
	out << "\\begin{document}" << std::endl;
	out << "\\includepdf[pages={" << s.str().c_str() << "},nup=2x2]{\"" << inputPDFfile << "\"}" << std::endl;
	out << "\\end{document}	" << std::endl;
	
	out.close();
}