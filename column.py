
import ifcopenshell
import csv
import FreeCAD
import importIFC

def capital(string):
    i = string.split('(')
    i[0] = i[0].upper()
    string='('.join(i)
    return string


def repeat(some, outputFile):
    for one in some:
        print(capital(str(one)))
       # listLine.append(capital(str(one)))
        print(capital(str(one)),';', file=outputFile)
        

Header = """ISO-10303-21;
HEADER;
FILE_DESCRIPTION(('ViewDefinition [CoordinationView]'),'2;1');
FILE_NAME('fr.ifc','2019-03-17 T 03:27:24',('',''),(''),'IfcOpenShell 0.5.0-dev','IfcOpenShell 0.5.0-dev','');
FILE_SCHEMA(('IFC2X3'));
ENDSEC;
DATA;
"""

Footer = """ENDSEC;
END-ISO-10303-21;
"""
f = input("Enter a file name without extension: ")
inputFile = ifcopenshell.open(f+"_FullModel.ifc")

#inputFile = ifcopenshell.open(r"C:/Users/JOBANDEEP SINGH/Desktop/Sample0_Cir_Column.ifc")

outputFile = open('Structure_Model_C.ifc','w')
outputFile.write(Header)

test = open("Testall.txt", 'r')
line = test.readline()

while line:
    print(line[:-1])
    one = inputFile.by_type(str(line[:-1]))
    repeat(one, outputFile)
    line = test.readline()

test.close()
outputFile.write(Footer)
outputFile.close()



#Data Extraction and design start


Str_model_file = ifcopenshell.open(f+"_FrameModel.ifc")

FreeCAD.open(f+"_FrameModel.FCStd")

def Check(string):
    i = string.split('=')
    j = i[1].split('(')
    string=j[0]
    return string


octave_input = open('octave_input_C.csv','w')
octave_input.write('Sr.No,')
octave_input.write('Name,')
octave_input.write('Length,')
octave_input.write('Width,')
octave_input.write('Height,')
octave_input.write('Fck,')
octave_input.write('Dia_C,')
x=1


Material= Str_model_file.by_type("IFCMATERIAL")

for Grade in Material:
    Fck1=Grade.Name
    Fck = Fck1.split('M')
    Fck = Fck[1].split('M')
    #print (Fck[0])
  
Columns = Str_model_file.by_type("IFCcolumn")

for Column in Columns:
    Name=Column.Name
    print ("Name " +str(Name))
    
    Checks=Column.Representation.Representations[0].Items[0].SweptArea

    if("IfcRectangleProfileDef" in (Check(str(Checks)))):
            Length=Column.Representation.Representations[0].Items[0].SweptArea.XDim
            print ("Length " +str(Length))
            Width=Column.Representation.Representations[0].Items[0].SweptArea.YDim
            print ("Width " +str(Width))
            Height=Column.Representation.Representations[0].Items[0].Depth
            print ("Height " +str(Height))

            octave_input.write('\n' + str(x))
            x=x+1
    
            octave_input.write(',' + Name)
            octave_input.write(','+str(Length))
            octave_input.write(',' + str(Width))
            octave_input.write(',' + str(Height))
            octave_input.write(',' + str(Fck[0]))
            octave_input.write(',' + "0")
            print ('\n')

    else:
        Dia_C=Column.Representation.Representations[0].Items[0].SweptArea.Radius
        print ("Radius " +str(Dia_C))
        Height=Column.Representation.Representations[0].Items[0].Depth
        print ("Height " +str(Height))

        octave_input.write('\n' + str(x))
        x=x+1
    
        octave_input.write(',' + Name)
        octave_input.write(',' + "0")
        octave_input.write(',' + "0")
        octave_input.write(',' + str(Height))
        octave_input.write(',' + str(Fck[0]))
        octave_input.write(',' + str((Dia_C)*2))

        print ('\n')
        
octave_input.close()


print ('\n\n Design Start  \n \n' )  


import oct2py
out = oct2py.Oct2Py()
out.source('main.m')

print ('\n\n Detailing Start  \n \n' )

import Script_FreeCAD

import importIFC

__objs__=[]

objts = [o for o in FreeCAD.ActiveDocument.Objects if hasattr(o, "IfcType")]

#objts = [o for o in FreeCAD.ActiveDocument.Objects]

for i in objts:
	__objs__.append(FreeCAD.ActiveDocument.getObject(i.Name))

importIFC.export(__objs__,u"Final_Rein_C.ifc")

del __objs__

FreeCAD.ActiveDocument.saveAs(u"Final_Rein_C.FCStd")

print ('\n\n Open Final_Rein_C.ifc \n \n' ) 







