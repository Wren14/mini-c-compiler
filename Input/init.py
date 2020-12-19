#file_name=input()
import re
file_name="Input/inp.c";
f=open(file_name,"r");
f=f.read();
l=f.split("\n");
ll=[]
for i in l:
	if((len(i)>0 and i[0]=="#") or i==""):
		continue
	else:
		#print(i.strip("\t"))
		ll.append(i.strip("\t"));
#print(ll);
#xx = "".join(ll);
#print(xx)
final_ip=[]
lll=ll[:]
final={}
dic={}
fname=[]
t="int |double "

dic_l=[]
for i in range(len(ll)):
	if(ll[i]=='{'):
		dic={}
		dic_l.append(dic)
		fname.append(ll[i-1])
	elif(ll[i]=='}'):
		final[fname[-1]]=dic_l[-1];
		fname=fname[:-1]
		dic_l=dic_l[:-1]
	else:
		p1=re.compile(t)
		p2=re.compile("[_a-zA-Z][0-9a-zA-Z]*");
		#variable declaration
		r1=p1.match(ll[i]);
		if(r1):
			#print(str(r1)+":"+ll[i]);
			r1=r1.span()
			typ=ll[i][r1[0]:r1[1]]
			
			ll[i]=ll[i][r1[1]:]
			r2=p2.match(ll[i])
			var=""
			val=11230;
			if(r2):
				r2=r2.span();
				var=ll[i][:r2[1]];
				
				ll[i]=ll[i][r2[1]:];
				#p3=re.compile("");
				p4=re.compile("=[0-9]+");
				
				if( p4.match(ll[i])):
					r4=p4.match(ll[i]);
					r4=r4.span();
					val=int(ll[i][r4[0]+1:r4[1]]);
					val_t=str(val)
					if("." in val_t):
						#index=val.find(".")
						val=int(val)
					#print("-->"+str(val))
			dic_l[-1][var]=[typ,val];
	
# this will write symbol table to a file		
fil=open("Output/symbol_table.txt","w");
#fil.write("--------------------------------")
#fil.write("\tSYMBOL TABLE\t");		
#fil.write("--------------------------------\n\n\n")
for i in final:
	fil.write("SCOPE : \t"+i);
	fil.write("\n")
	fil.write("\tname\ttype\tvalue\n") 
	fil.write("\t--------------------------\n")
	for j in final[i]:
		fil.write("\t"+j+"\t"+final[i][j][0]+"\t"+str(final[i][j][1])+"\n");
	fil.write("\n______________________________________________\n\n")
#fil.write("\n\n\n------------------------------------------------------------------------------------\n\n");				
fil.close()	

#generating output for next phase
fin=[]
start_if=[False]
if_str=[]
ll=lll[:]
j=-1
for i in range(len(ll)):
	if(start_if[-1] and ll[i][0:2]!="if"):
		if("int" in ll[i]):
			ll[i]=ll[i].replace("int ","")
		elif("double" in ll[i]):
			ll[i]=ll[i].replace("double ","")
		fin[j]+=ll[i]
	if(ll[i][0:2]=="if" ):
		fin.append(ll[i]);
		start_if.append(True)
	
	if(ll[i]=="}"):
		if((i+1)<len(ll)  and ll[i+1]!="else"):
			start_if.pop()
			#j-=1
print("".join(fin))

	
		
