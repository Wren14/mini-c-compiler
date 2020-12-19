cd Input
g++-6 remove_comments.cpp -o remove_comments
./remove_comments >../Output/inp.c
cp ../Output/inp.c ./inp.c
cd ..

python3 ./Input/init.py >./Output/phase_1.txt
cd Input
yacc -d final_nested_expr_nowarn_latest.y -Wno-conflicts-sr;
lex final.l;
gcc y.tab.c  -ll -ly -Wno-implicit  -o execute
cd ..
./Input/execute < ./Output/phase_1.txt > Output/ThreeAddressCode.txt

mkdir Temp
cd Temp
cp ../Input/inp.c ./ip.c
gcc -fdump-tree-all-graph ip.c
dot -Tpng ip.c.045t.release_ssa.dot > ../Output/SSA.png

gcc -fdump-tree-original-raw ip.c
cp ../Input/pre.awk ./pre.awk
cp ../Input/treewiz.awk ./treewiz.awk
awk -f pre.awk ip.c.003t.original | awk -f treewiz.awk >tree.dot
dot -Tpng tree.dot>../Output/AST.png
cd ..
rm -rf Temp
cd Output
mv phase_1.txt lexer_output.txt
mv inp.c comments_removed_input.c
cd ..
reset
