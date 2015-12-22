
def splitlist(projlist,splitat):
	if splitat in projlist:
		proj1=projlist[:projlist.index(splitat)]
		proj2=projlist[projlist.index(splitat):]
		print("Proj1 " , proj1 )
		print("Proj2 " , proj2 )
	else:
		print("%s in not in the list " % splitat , projlist)

keyproj="Unity"
projects1=["ABC","SCU","sau","Unity","ut1","ut2"]
projects2=["ABC","SCU","sau","unity","ut1","ut2"]
splitlist(projects1,keyproj)
splitlist(projects2,keyproj)
